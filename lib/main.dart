import 'package:flutter/material.dart';
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
      home: HomePage(),
      routes: {
        HomePage.id: (context)=>HomePage(),
        ContactsPage.id: (context)=>const ContactsPage(),
      },
    );
  }
}


