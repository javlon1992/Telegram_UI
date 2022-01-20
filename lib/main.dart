import 'package:flutter/material.dart';
import 'package:task_6/pages/LoginPage.dart';
import 'package:task_6/pages/contacts_page.dart';
import 'package:task_6/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        HomePage.id: (context)=>HomePage(),
        ContactsPage.id: (context)=>ContactsPage(),
        LoginPage.id: (context)=> LoginPage(),
      },
    );
  }
}


