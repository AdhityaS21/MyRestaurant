import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({this.id, this.restName});

  final String? restName;
  final id;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              _settingModalBottomSheet(context);
            },
          ),
        ],
        title: Text(
          "Reviews",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('Reviews')
            .where('restKey', isEqualTo: id)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data!.docs.isEmpty){
              return Container(
                alignment: Alignment.center,
                child: Text("belum ada review"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> task = document.data()!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle_rounded,
                              color: Colors.grey, size: 50),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                task['date'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(task['review']),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Text("Loading ..."),
            );
          }
        },
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    TextEditingController nameController = new TextEditingController(), reviewController = new TextEditingController();

    showModalBottomSheet(
      enableDrag: false,
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            height: 300,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "Add review",
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Your Name",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    hintText: "Review",
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 320,
                  child: ElevatedButton(
                    //color: Colors.blue,
                    onPressed: () {
                      firestore.collection('Reviews').add({
                        'restKey': id,
                        'name': nameController.text,
                        'review': reviewController.text,
                        'date': DateFormat.yMMMMd().format(DateTime.now()),
                      });
                      nameController.text = '';
                      reviewController.text = '';

                      Navigator.pop(_);
                    },
                    //textColor: Colors.white,
                    //padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Simpan', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
  }