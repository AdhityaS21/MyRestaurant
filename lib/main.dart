import 'package:myrestaurant/bloc/nightmode_bloc.dart';
import 'package:myrestaurant/navigationBLoC.dart';
import 'package:myrestaurant/screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NightmodeBloc>(create: (context) => NightmodeBloc(),),
        BlocProvider<NavigateBloc>(create: (context) => NavigateBloc(0),),
      ],
      child: BlocBuilder<NightmodeBloc, NightmodeState>(
        builder: (context, state) {
          return GetMaterialApp(
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            theme: ThemeData(
              brightness: Brightness.light,
            ),
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            title: "Restaurant",
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
