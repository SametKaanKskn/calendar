import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Ekranı'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8),
                elevation: 5,
                shadowColor: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(data['email'] ?? 'Unknown'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (data['userTypes'] != 'Admin') {
                        _firestore
                            .collection('users')
                            .doc(docs[index].id)
                            .delete();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Admin kullanıcılar silinemez!'),
                        ));
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}