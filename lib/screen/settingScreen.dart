import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrestaurant/bloc/nightmode_bloc.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isSwitched = false, isSwitched2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NightmodeBloc, NightmodeState>(
        builder: (context, state) {
      (state.themeMode == ThemeMode.light) ? isSwitched2 = false : isSwitched2 = true;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(
                color: (state.themeMode == ThemeMode.light)
                    ? Colors.black
                    : Colors.white),
          ),
          backgroundColor: (state.themeMode == ThemeMode.light)
              ? Colors.white
              : Colors.black,
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
                  Icon(Icons.nights_stay, color: Colors.grey),
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
                          (state.themeMode == ThemeMode.light)
                              ? "Change to Night Mode"
                              : "Change to Light Mode",
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
                        print(state.themeMode);
                        BlocProvider.of<NightmodeBloc>(context)
                            .add(ThemeChanged(value));
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
    });
  }
}
