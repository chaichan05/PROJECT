import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/admin.dart';
import 'package:project/client.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage2(),
    );
  }
}

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/bbq.png'),
          alignment: Alignment.centerLeft,
        ),
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          'IT BBQ',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          textAlign: TextAlign.right,
        ),
        backgroundColor: const Color(0xFFFA6C6B),
      ),
    );
  }
}
