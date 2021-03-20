import 'package:MyRestaurant/navigationBLoC.dart';
import 'package:MyRestaurant/screen/aboutMeScreen.dart';
import 'package:MyRestaurant/screen/detailRestaurantScreen.dart';
import 'package:MyRestaurant/screen/favoriteScreen.dart';
import 'package:MyRestaurant/screen/searchProvider.dart';
import 'package:MyRestaurant/screen/settingScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = [
      RestaurantScreen(),
      FavoriteScreen(),
      AboutMeScreen(),
      SettingScreen(),
    ];

    // ignore: close_sinks
    NavigateBloc bloc = BlocProvider.of<NavigateBloc>(context);
    return Scaffold(
      body: BlocBuilder<NavigateBloc, int>(builder: (context, state) {
        return Stack(
          children: [
            body[state],
            Container(
              alignment: Alignment.bottomCenter,
              width: 395,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  height: 55,
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: Offset(10, 15),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.restaurant,
                          color: (state == 0) ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          bloc.add(NavigateEvent.toRestaurant);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: (state == 1) ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          bloc.add(NavigateEvent.toFavorite);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          color: (state == 2) ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          bloc.add(NavigateEvent.toMe);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: (state == 3) ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          bloc.add(NavigateEvent.toSetting);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var restCollection = firestore.collection('Restaurant').orderBy('restName').snapshots();

    return ChangeNotifierProvider<SearchProvider>(
      create: (context) => SearchProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Restaurant",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 35,
              padding: EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.black12),
                ),
                child:
                    Consumer<SearchProvider>(builder: (context, provider, _) {
                  return TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        size: 20.0,
                      ),
                      hintText: "Search",
                    ),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    onChanged: (value) {
                      int svalue = value.length;
                      provider.searchQuery = svalue;
                      (provider.searchQuery >= 1)
                          ? restCollection = firestore
                              .collection('Restaurant')
                              .where('restName', isGreaterThanOrEqualTo: value, isLessThan: value.substring(0, value.length-1)+String.fromCharCode(value.codeUnitAt(value.length-1)+1))
                              .snapshots()
                          : restCollection =
                              firestore.collection('Restaurant').orderBy('restName').snapshots();
                    },
                  );
                }),
              ),
            ),
            Expanded(
              child: Consumer<SearchProvider>(builder: (context, provider, _) {
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: restCollection,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text("Belum ada restaurant"),
                            );
                          }
                          return Container(
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              staggeredTileBuilder: (index) =>
                                  new StaggeredTile.fit(2),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (_, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> task = document.data()!;
                                return GestureDetector(
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black12.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            height:128,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              image: DecorationImage(
                                                image: ((task['imgURL'] != null)
                                                        ? NetworkImage(task['imgURL'])
                                                        : AssetImage(
                                                            'assets/restaurant1.jpg'))
                                                    as ImageProvider<Object>,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              task['restLoc'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              task['restName'],
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              task['restDesc'],
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(DetailRestaurantScreen(
                                      restName: task['restName'],
                                      restLoc: task['restLoc'],
                                      restDesc: task['restDesc'],
                                      restFav: task['restFav'],
                                      id: document.id,
                                    ));
                                  },
                                );
                              },
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
