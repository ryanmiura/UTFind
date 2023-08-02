import 'package:flutter/material.dart';
import 'package:utfind/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        //useMaterial3: true,
        primarySwatch: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}
