import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CanteenEnd extends StatelessWidget {
  static const routeName = 'CanteenEnd';

  final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
      .collection('Orders')
      .orderBy('PlacedAt', descending: false)
      .snapshots();
  Future<void> batchDelete() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final orders = FirebaseFirestore.instance.collection('Orders');

    return orders.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
      }

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
        title: const Text('Canteen Admin'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          //In case orders loading

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          var orders = snapshot.data!.docs;

          if(orders.isEmpty){
            return const Center(
              child: Text('No orders yet'),
            );
          }
          //return list when fetched
          return ListView.builder(
            itemBuilder: ((context, index) {
              var data = orders[index].data() as Map<String, dynamic>;
              return _buildListTile(
                  index,
                  data['ImageUrl'],
                  data['ItemName'],
                  data['OrderId'],
                  data['PlacedBy'],
                  data['PlacedAt'],
                  orders[index].id);
            }),
            itemCount: orders.length,
          );
        }),
        stream: _orderStream,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          batchDelete();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.done),
      ),
    );
  }
}

Widget _buildListTile(int index, String imageUrl, String itemName, int orderId,
    String placedBy, Timestamp placedAt, String orderUid) {
  Future<void> _listItemDismissed(String orderUid) async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderUid.toString())
        .delete();
  }

  return Dismissible(
    key: ValueKey(orderId),
    direction: DismissDirection.endToStart,
    background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              size: 35,
              color: Colors.white,
            ),
          ),
        )),
    onDismissed: (direction) async {
      await _listItemDismissed(orderUid);
    },
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 30,
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(placedAt.toDate().toLocal().toString()),
                  ],
                ),
                const Spacer(),
                Text(
                  '#${index + 1}',
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Placed by $placedBy',
              style:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15),
            ),
            const Divider(
              color: Colors.red,
            )
          ],
        ),
      ),
    ),
  );
}
