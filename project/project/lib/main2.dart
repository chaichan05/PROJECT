import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/admin.dart';
import 'package:project/client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        flexibleSpace: Image(
          image: const AssetImage('assets/bbq.png'),
          alignment: Alignment.centerLeft,
        ),
        toolbarHeight: 70,
        centerTitle: true,
        title: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Text(
            'IT BBQ',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        backgroundColor: const Color(0xFFFA6C6B),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 30.30),
          const SizedBox(height: 30.30),
          const SizedBox(height: 30.30),
          const SizedBox(height: 30.30),
          const SizedBox(height: 30.30),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6C6B),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              textStyle: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // Handle button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientPage()),
              );
            },
            child: const Text('ลูกค้า', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16.0), //เอามาเพิ่มช่องว่าง
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6C6B),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              textStyle: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // Handle button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              );
            },
            child: const Text('Admin', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}
