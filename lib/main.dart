import 'package:flutter/material.dart';
import 'package:flutter_avanzado1_bandnameapp/src/pages/home_page.dart';
import 'package:flutter_avanzado1_bandnameapp/src/pages/status.dart';
import 'package:flutter_avanzado1_bandnameapp/src/services/socket_service.dart';
import 'package:provider/provider.dart';



void main() {

  
   runApp( MyApp() );
   
   }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      
      ],

      

  child:
  
       MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => HomePage(),
          'status': (context) => StatusPage(),
            //  '/second': (context) => SecondPage(),
        },
        
      ));
    
  }
}