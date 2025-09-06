import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/book.dart';

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
      home: const ClientPage(),
    );
  }
}

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

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

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to IT BBQ!',
                  style: GoogleFonts.playfairDisplay(
                    color: const Color(0xFFFA6C6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ชื่อผู้ใช้',
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'รหัสผ่าน',
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  obscureText: true, // 👈 เพิ่มเพื่อซ่อนรหัสผ่าน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const BookPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6C6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}
