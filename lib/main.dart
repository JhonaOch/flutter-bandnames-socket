import 'package:flutter/material.dart';
import 'package:flutter_avanzado1_bandnameapp/src/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
       // '/second': (context) => SecondPage(),
      },
      
    );
  }
}