import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrestaurant/bloc/nightmode_bloc.dart';
import 'package:myrestaurant/screen/detailRestaurantScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return BlocBuilder<NightmodeBloc, NightmodeState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Favorite",
            style: TextStyle(color: (state.themeMode == ThemeMode.light) ? Colors.black : Colors.white),
          ),
          elevation: 0,
          backgroundColor: (state.themeMode == ThemeMode.light) ? Colors.white : Colors.black,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 18.0, right: 18.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("Restaurant")
                .where("restFav", isEqualTo: true)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text("belum ada favorite"),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> task = document.data()!;
                    return GestureDetector(
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 3),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 129,
                                width: 190,
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
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                );
              }
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      );
    });
  }
}
