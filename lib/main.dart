import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/Home_page.dart';
import 'Screens/add money page.dart';
import 'Screens/total.dart';
import 'components/login_page.dart';
import 'components/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBA9xv8ZPRtf7K4YkwEY4jb_dxE3dEBmc0',
        appId: '1:511706050107:android:ed12b8e0d798f3db0c361e',
        messagingSenderId: '511706050107',
        projectId: 'money-manager-962f5',)):
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MoneyHome(),
    );
  }
}
