import 'package:MyRestaurant/nightModeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false, isSwitched2 = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(Colors.white),
      child: BlocBuilder<ThemeBloc, Color>(builder: (context, state) {
          // ignore: close_sinks
          ThemeBloc bloc = BlocProvider.of<ThemeBloc>(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: state,
              elevation: 0,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.grey),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RestaurantNotification",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Notification every 11 AM",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.grey),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Change to Night Mode",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Change to Night Mode",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isSwitched2,
                    onChanged: (value) {
                      setState(() {
                        isSwitched2 = value;
                        print(isSwitched2);
                        (isSwitched2 == true) ? bloc.add(ThemeEvent.toNightMode) : bloc.add(ThemeEvent.toLightMode);
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              // SwitchListTile(
              //   value: true,
              //   onChanged: (value){
              //   },
              // ),
            ],
          ),
        ),
      );
    }));
  }
}