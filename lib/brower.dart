import 'package:flutter/material.dart'; 
void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget { 
   @override 
   Widget build(BuildContext context) {
      return MaterialApp(
         title: 'Flutter Demo', 
         theme: ThemeData( 
            primarySwatch: Colors.blue, 
         ), 
         home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
   }
}
class MyHomePage extends StatelessWidget { 
   MyHomePage({Null key, required this.title}) : super(key: key); 
   final String title; 
   
   @override 
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            title: Text(this.title), 
         ), 
         body: Center(
            child: ElevatedButton( 
               child: Text('Open Browser'), 
               onPressed: null, 
            ), 
         ), 
      ); 
   }
}