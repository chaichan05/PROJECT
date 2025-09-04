// import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/queue.dart';
// import 'package:project/client.dart';

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
      home: const BookPage(),
    );
  }
}

class BookPage extends StatelessWidget {
  const BookPage({super.key});

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

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ไม่ยืดเต็มแนวตั้ง
            crossAxisAlignment: CrossAxisAlignment.center, // ชิดกลางแนวนอน 
            // crossAxisAlignment: CrossAxisAlignment.start, //  ชิดซ้าย
            children: [
              // ถ้าอยากให้หัวข้อยังอยู่กึ่งกลาง ให้ห่อด้วย Align แยกต่างหาก
              Align(
                alignment: Alignment.center,
                child: Text(
                  'การจองคิว',
                  style: GoogleFonts.playfairDisplay(
                    color: Color(0xFFFA6C6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                  alignment: Alignment.centerLeft,// ชิดซ้าย
                  child: Text('ชื่อลูกค้า', style: GoogleFonts.openSans(fontSize: 16),)),
              SizedBox(
                width: double.infinity, // ให้ TextField กว้างเต็มที่
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
        
              Align(
                  alignment: Alignment.centerLeft,// ชิดซ้าย
                  child:Text('จำนวนคน', style: GoogleFonts.openSans(fontSize: 16))),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
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
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('การจองสำเร็จ'),
                          content: Text('ขอบคุณที่ใช้บริการ'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const QueuePage()));
                              },
                              child: Text('ตกลง'),
                            ),
                          ],
                        );
                      },
                    )
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6C6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ยืนยันการจอง',
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
