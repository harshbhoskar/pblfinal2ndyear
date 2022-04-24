import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'meal.dart';
import 'meal_item.dart';
import 'meal_detail_screen.dart';

class CartScreen extends StatelessWidget {
  final List<Meal> cartMeals;

  CartScreen(this.cartMeals);

  Future<void> uploadOrder(
      FirebaseFirestore ref, BuildContext context, String uid) async {
    for (int index = 0; index < cartMeals.length; index++) {
      await ref.collection('Users').doc(uid).collection('orders').add({
        "id": cartMeals[index].id,
        'title': cartMeals[index].title,
        'imageUrl': cartMeals[index].imageUrl,
        'duration': cartMeals[index].duration
      });
    }
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
        body: ListView.builder(
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
    }
  }
}
