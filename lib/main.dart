import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/screens/EntryPoint/EntryPoint.dart';
import 'package:projet_fin_annee_2gt/screens/OnBoardingScreens/onbording_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Repository/user_repository.dart';
import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthentificationRepository()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isFirstTimeUser = false;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTimeUser();
  }

  Future<void> _checkIfFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? true;

    if (isFirstTimeUser) {
      print("3-------------------------------------------");
      setState(() {
        _isFirstTimeUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Reclami',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      home: _isFirstTimeUser?OnBoardingScreen(): EntryPoint(),

    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
