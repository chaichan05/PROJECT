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

      body: Stack(
        children: [
          // เนื้อหาหลัก (เลื่อนด้วย ListView ได้)
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 300),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClientPage(title: 'ลูกค้า',)),
                  );
                },
                child: const Text(
                  'ลูกค้า',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPage()),
                  );
                },
                child: const Text(
                  'Admin',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          // ปุ่มย้อนกลับล่างซ้าย
          Positioned(
            top: 20,
            left: 20,
            child: Material(
              color: Color(0xFFF6FBFE),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ],
      ),

      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}