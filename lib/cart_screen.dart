import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'meal.dart';
import 'meal_item.dart';
import 'meal_detail_screen.dart';

class CartScreen extends StatelessWidget {
  late List<MealItem> cartMeals;

  CartScreen();

  Future<void> uploadOrder(
      FirebaseFirestore ref, BuildContext context, String uid) async {
    String userName;

    try {
      userName = await ref
          .collection('Users')
          .doc(uid)
          .get()
          .then((value) => value.data()!['Name']);
    } catch (e) {
      userName = 'Anonymous';
    }

    for (int index = 0; index < cartMeals.length; index++) {
      int latestOrderId = await ref
          .collection('LatestOrderId')
          .doc('orderId')
          .get()
          .then((value) => value.data()!['LatestOrderNumber']);
      await ref.collection('Orders').add({
        'ItemName': cartMeals[index].title,
        'ImageUrl': cartMeals[index].imageUrl,
        'OrderId': latestOrderId,
        'PlacedBy': userName,
        'PlacedAt': Timestamp.now(),
        'PrepTime': cartMeals[index].duration,
        'Price': 100 //change this to variable price of your choice
      });

      await ref.collection('Users').doc(uid).collection('orders').add({
       'ItemName': cartMeals[index].title,
        'ImageUrl': cartMeals[index].imageUrl,
        'OrderId': latestOrderId,
        'PlacedBy': userName,
        'PlacedAt': Timestamp.now(),
        'PrepTime': cartMeals[index].duration,
        'Price': 100
      });

      await ref
          .collection('LatestOrderId')
          .doc('orderId')
          .update({'LatestOrderNumber': FieldValue.increment(1)});
    }
    await batchDelete(uid);
  }

  Future<void> batchDelete(String uid) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final orders = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('orders');
    return orders.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    if (cartMeals.isEmpty) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            batchDelete(uid);
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.delete),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await uploadOrder(firestore, context, uid);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('orders')
                .snapshots(),
            builder: (ctx, snapshot) {

              if(cartMeals == null || cartMeals.isEmpty) {
                return Center(
                  child: Text('No items in cart'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );

               cartMeals =  snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return MealItem(id: data[''], title: data['ItemName'], imageUrl: data['ImageUrl'], affordability: Affordability.Affordable, complexity: Complexity.Simple, duration: 20,);
              }).toList();

              return Container(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return MealItem(
                        id: cartMeals[index].id,
                        title: cartMeals[index].title,
                        imageUrl: cartMeals[index].imageUrl,
                        affordability: cartMeals[index].affordability,
                        complexity: cartMeals[index].complexity,
                        duration: cartMeals[index].duration);
                  },
                  itemCount: cartMeals.length,
                ),
              );
            }),
      );
    }
  }
}
