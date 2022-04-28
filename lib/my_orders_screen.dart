import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pbl_studentend_clubbed/meal.dart';
import 'package:pbl_studentend_clubbed/meal_item.dart';

class MyOrdersScreen extends StatefulWidget {
  String uid;
  MyOrdersScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.uid)
            .collection('orders')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error Occured'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Orders !'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final listData =
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                return MealItem(
                  id: '1',
                  title: listData['ItemName'],
                  imageUrl: listData['ImageUrl'],
                  affordability: Affordability.Affordable,
                  complexity: Complexity.Simple,
                  duration: 20,
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
