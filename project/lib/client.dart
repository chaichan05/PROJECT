import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:project/book.dart';
import 'package:project/queue.dart';
import 'package:project/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ClientPage(title: 'IT BBQ'),
    );
  }
}

class ClientPage extends StatefulWidget {
  const ClientPage({super.key, required this.title});
  final String title;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  String? user;
  String? people;
  int queteue = 1; // เพิ่มฟิลด์หมายเลขคิว
  final _formKey = GlobalKey<FormState>();

  // แก้จากเดิมที่ void → ให้คืนค่า String (docId)
  Future<String> saveUserData(String user, String people) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    // หา queteue ที่มากที่สุดใน users
    final snapshot = await usersRef.orderBy('queteue', descending: true).limit(1).get();
    int nextQueue = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastQueue = snapshot.docs.first.data()['queteue'];
      if (lastQueue is int) {
        nextQueue = lastQueue + 1;
      }
    }

    final doc = await usersRef.add({
      'queteue': nextQueue,
      'username': user,
      'people': int.tryParse(people) ?? 1,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return doc.id; // ✅ คืน docId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/bbq.png'),
          alignment: Alignment.centerLeft,
        ),
        automaticallyImplyLeading: false, // ❌ ไม่ต้องแสดงปุ่ม back อัตโนมัติ
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

      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
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
                  const SizedBox(height: 100),

                  // ชื่อผู้ใช้
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "ชื่อผู้ใช้",
                        prefixIcon: const Icon(Icons.person),
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
                        errorMessage: 'กรุณากรอกชื่อผู้ใช้',
                      ),
                      onChanged: (value) {
                        user = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // จำนวนคน
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
                        people = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ปุ่มเข้าสู่ระบบ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final id = await saveUserData(user!, people!);

                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QueuePage(docId: id),
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
                        'จองคิว',
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

            // ปุ่มย้อนกลับ
            Positioned(
              top: 20,
              left: 20,
              child: Material(
                color: const Color(0xFFF6FBFE),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    try {
                      // บันทึกข้อมูลผู้ใช้
                      final id = await saveUserData(user!, people!);

                      // ถ้าบันทึกสำเร็จ ให้ไปหน้า QueuePage
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => QueuePage(
                                docId: id,
                              ), // ส่ง docId ไปหน้า QueuePage
                        ),
                      );
                    } catch (e) {
                      // ถ้ามีข้อผิดพลาด
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ไม่สามารถบันทึกข้อมูลได้')),
                      );
                    }
                  },

                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}
