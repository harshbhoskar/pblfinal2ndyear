import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class CanteenEnd extends StatelessWidget {
  static const routeName = 'CanteenEnd';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('canteen end'),
      ),
      body: const Center(child: Text('your orders-')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          batchDelete(uid);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.done),
      ),
    );
  }
}
