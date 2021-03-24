import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myrestaurant/bloc/nightmode_bloc.dart';
import 'package:myrestaurant/screen/detailRestaurantScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return BlocBuilder<NightmodeBloc, NightmodeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "About Me",
              style: TextStyle(color: (state.themeMode == ThemeMode.light) ? Colors.black : Colors.white),
            ),
            elevation: 0,
            backgroundColor: (state.themeMode == ThemeMode.light) ? Colors.white : Colors.black,
          ),
          body: Container(
            margin: EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  "Agung S",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),  SizedBox(height: 15),
            Text(
              "Bandung",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextButton(
                child: Row(
                  children: [
                    Image.asset("assets/linkedin.png", width: 50, height: 50),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LinkedIn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          Text(
                            "Let's Connect",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.navigate_next, color: Colors.grey, size: 40),
                  ],
                ),
                onPressed: () async {
                  await canLaunch('https://www.linkedin.com/') ? await launch('https://www.linkedin.com/') : throw 'Could not launch https://www.linkedin.com/';
                },
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 18.0),
              child: Text(
                "Favorite Restaurants",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                height: 450,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection("Restaurant")
                      .where("restFav", isEqualTo: true)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          child: Text("belum ada favorite"),
                        );
                      }
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        staggeredTileBuilder: (index) => new StaggeredTile.fit(2), mainAxisSpacing: 10, crossAxisSpacing: 10,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index){
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          Map<String, dynamic> task = document.data()!;
                          return GestureDetector(
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(
                                    color: Colors.black12.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 3),
                                  )],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:129,
                                      width: 190,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        image: DecorationImage(
                                          image: ((task['imgURL'] != null)
                                            ? NetworkImage(task['imgURL'])
                                            : AssetImage('assets/restaurant1.jpg')) as ImageProvider<Object>,
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
                                    SizedBox(height: 10, width: 10,),
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
}