import 'package:myrestaurant/navigationBLoC.dart';
import 'package:myrestaurant/screen/reviewScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DetailRestaurantScreen extends StatelessWidget {
  const DetailRestaurantScreen(
      {this.restName, this.restLoc, this.restDesc, this.restFav, this.id, this.restImg});

  final String? restName;
  final String? restLoc;
  final String? restDesc;
  final bool? restFav;
  final id;
  final restImg;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return BlocProvider<FavoriteBloc>(
      create: (context) => FavoriteBloc((restFav == true) ? Icon(Icons.favorite) : Icon(Icons.favorite_border, color: Colors.grey)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(
            restName!,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: restName!,
                      child: Container(
                        child: Image.asset("assets/restaurant1.jpg"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              restName!,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Icon(Icons.location_pin, size: 15),
                                SizedBox(width: 3),
                                Text(
                                  restLoc!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Description",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              restDesc!,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 80,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('Reviews')
                                  .where('restKey', isEqualTo: id)
                                  .limit(1)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text("Belum ada review"),
                                    );
                                  }
                                  return ListView.builder(
                                    primary: false,
                                    shrinkWrap: false,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (_, index) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];
                                      Map<String, dynamic> task =
                                          document.data()!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .account_circle_rounded,
                                                    color: Colors.grey,
                                                    size: 50),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task['name'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      task['date'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                              task['review'],
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
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
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: GestureDetector(
                              child: Text(
                                "Lihat Selengkapnya",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () {
                                Get.to(
                                  ReviewScreen(
                                    id: id,
                                    restName: restName,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Foods",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('Foods')
                                  .where('restKey', isEqualTo: id)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text("belum ada makanan"),
                                    );
                                  }
                                  return GridView.count(
                                    scrollDirection: Axis.horizontal,
                                    crossAxisCount: 1,
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];
                                      Map<String, dynamic> task =
                                          document.data()!;
                                      return GestureDetector(
                                        child: Container(
                                          child: Card(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (task['imgURL'] != null)
                                                    ? Image.network(
                                                        task['imgURL'])
                                                    : Image.asset(
                                                        'assets/img2.jpg'),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    task['foodName'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                } else {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text("Loading ..."),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Drinks",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('Drinks')
                                  .where('restKey', isEqualTo: id)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text("belum ada minuman"),
                                    );
                                  }
                                  return GridView.count(
                                    scrollDirection: Axis.horizontal,
                                    crossAxisCount: 1,
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];
                                      Map<String, dynamic> task =
                                          document.data()!;
                                      return GestureDetector(
                                        child: Container(
                                          child: Card(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (task['imageURL'] != null)
                                                    ? Image.network(
                                                        task['imageURL'])
                                                    : Image.asset(
                                                        'assets/img2.jpg'),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    task['drinkName'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                } else {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text("Loading ..."),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: MediaQuery.of(context).size.height * 0.36,
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: firestore
                          .collection('Restaurant')
                          .doc(id)
                          .snapshots(),
                      builder: (_, snapshot) {
                        return BlocBuilder<FavoriteBloc, Icon>(
                            builder: (context, state) {
                          if (snapshot.hasData) {
                            var task = snapshot.data!;
                            // ignore: close_sinks
                            FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);
                            return TextButton(
                              onPressed: () {
                                if (task['restFav'] == false) {
                                  print(task['restFav']);
                                  fav();
                                  bloc.add(FavoriteEvent.toFavorite);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Berhasil menambahkan ke favorite'),
                                    duration: Duration(seconds: 2),
                                  ));
                                } else {
                                  print(task['restFav']);
                                  noFav();
                                  bloc.add(FavoriteEvent.toUnFavorite);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Berhasil menghapus dari favorite'),
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: state,
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fav() {
    FirebaseFirestore.instance.collection('Restaurant').doc(id).update({
      'restFav': true,
    });
  }

  void noFav() {
    FirebaseFirestore.instance.collection('Restaurant').doc(id).update({
      'restFav': false,
    });
  }
}
