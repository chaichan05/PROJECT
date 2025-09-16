// import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/queue.dart';
import 'package:project/validator/validator.dart';
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
      home: const BookPage(title: "Book Page"),
    );
  }
}

class BookPage extends StatefulWidget {
  const BookPage({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  String? user;
  double? person;
  final _formKey = GlobalKey<FormState>();

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

      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ไม่ยืดเต็มแนวตั้ง
                // crossAxisAlignment: CrossAxisAlignment.center, // ชิดกลางแนวนอน
                // crossAxisAlignment: CrossAxisAlignment.start, //  ชิดซ้าย
                children: [
                  // ถ้าอยากให้หัวข้อยังอยู่กึ่งกลาง ให้ห่อด้วย Align แยกต่างหาก
                  const SizedBox(height: 60),
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
                  const SizedBox(height: 100),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "ชื่อลูกค้า",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      validator: Validator.required(
                        errorMessage: 'กรุณากรอกชื่อลูกค้า',
                      ),
                      onChanged: (value) {
                        user = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "จำนวนคน",
                        prefixIcon: Icon(Icons.group_add),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      validator: Validator.multiValidator([
                        Validator.required(errorMessage: 'กรุณากรอกจำนวนคน'),
                        Validator.numberValidator(
                          errorMessage: 'กรุณากรอกจำนวนคนเป็นตัวเลข',
                        ),
                      ]),
                      onChanged: (value) {
                        person = double.tryParse(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (user == null || user!.isEmpty) return;

                          try {
                            final snapshot =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .where(
                                      'username',
                                      isEqualTo: user,
                                    ) // 👈 แก้ field ให้ตรงกับที่คุณเก็บจริง
                                    .limit(1)
                                    .get();

                            if (snapshot.docs.isNotEmpty) {
                              // พบผู้ใช้
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('การจองสำเร็จ'),
                                    content: const Text('ขอบคุณที่ใช้บริการ'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const QueuePage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'ตกลง',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                       
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // ไม่พบผู้ใช้
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'ไม่พบชื่อในระบบ กรุณาสมัครก่อนจองคิว',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            // ⚠️ กรณี error จาก Firestore
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                            );
                          }
                        }
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
