import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/book.dart';
import 'package:project/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  String? password;
  final _formKey = GlobalKey<FormState>();

  Future<void> saveUserData(String user, String password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'username': user,
      'password': password,
      "timestamp": FieldValue.serverTimestamp(),
    });
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

                  // รหัสผ่าน
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "รหัสผ่าน",
                        prefixIcon: const Icon(Icons.lock),
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
                        errorMessage: 'กรุณากรอกรหัสผ่าน',
                      ),
                      onChanged: (value) {
                        password = value;
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

                          await saveUserData(user!, password!);

                          if (!mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BookPage(title: 'หน้าจองคิว'),
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

            // ปุ่มย้อนกลับ
            Positioned(
              top: 20,
              left: 20,
              child: Material(
                color: const Color(0xFFF6FBFE),
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
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}
