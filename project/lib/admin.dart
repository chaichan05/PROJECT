import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:project/book.dart';
import 'package:project/validator/validator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:project/adminpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AdminLogin(title: 'IT BBQ'),
    );
  }
}

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key, required this.title});
  final String title;

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String? user;
  String? password;
  final _formKey = GlobalKey<FormState>();

  // Future<void> saveUserData(String user, String password) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'username': user,
  //     'password': password,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });
  // }

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
            Positioned(
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
                      'ยืนยันตัวตน',
                      style: GoogleFonts.playfairDisplay(
                        color: const Color(0xFFFA6C6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),

                  // ชื่อผู้ใช้
                  // ช่องชื่อผู้ใช้
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
                      ),
                      validator: Validator.accountValidator(),
                      onChanged: (value) => user = value,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ช่องรหัสผ่าน
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
                      ),
                      validator: Validator.passwordValidator(),
                      onChanged: (value) => password = value,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ปุ่มเข้าสู่ระบบ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ถ้าผ่าน validator ทั้งคู่
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPage(),
                            ),
                          );
                        }
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

            
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }
}


// // import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:project/adminpage.dart';
// import 'package:project/validator/validator.dart';
// //import 'package:project/client.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const Admin(title: "Admin"),
//     );
//   }
// }

// class Admin extends StatefulWidget {
//   const Admin({super.key, required this.title});
//   final String title;

//   @override
//   // ignore: library_private_types_in_public_api
//   _BookPageState createState() => _BookPageState();
// }

// class _BookPageState extends State<Admin> {
//   String? accoutadim;
//   double? person;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Image(
//           image: const AssetImage('assets/bbq.png'),
//           alignment: Alignment.centerLeft,
//         ),
//         toolbarHeight: 70,
//         centerTitle: true,
//         title: ConstrainedBox(
//           constraints: BoxConstraints(),
//           child: Text(
//             'IT BBQ',
//             style: GoogleFonts.playfairDisplay(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 32,
//             ),
//             textAlign: TextAlign.right,
//           ),
//         ),
//         backgroundColor: const Color(0xFFFA6C6B),
//       ),

//       body: Stack(
//         children: [
//           Form(
//             key: _formKey,
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // ไม่ยืดเต็มแนวตั้ง
//                 // crossAxisAlignment: CrossAxisAlignment.center, // ชิดกลางแนวนอน
//                 // crossAxisAlignment: CrossAxisAlignment.start, //  ชิดซ้าย
//                 children: [
//                   // ถ้าอยากให้หัวข้อยังอยู่กึ่งกลาง ให้ห่อด้วย Align แยกต่างหาก
//                   const SizedBox(height: 60),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'ยืนยันตัวตน',
//                       style: GoogleFonts.playfairDisplay(
//                         color: Color(0xFFFA6C6B),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 36,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                   SizedBox(
//                     width: double.infinity,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: "ชื่อผู้ดูแลระบบ",
//                         prefixIcon: Icon(Icons.person),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 12,
//                           horizontal: 16,
//                         ),
//                       ),
//                       validator:
//                           Validator.required(
//                             errorMessage: 'กรุณากรอกชื่อผู้ดูแลระบบ',
//                           ),
//                       onChanged: () {
//                         user = value;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: "รหัสผ่าน",
//                         prefixIcon: Icon(Icons.lock),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 12,
//                           horizontal: 16,
//                         ),
//                       ),
//                       validator: Validator.multiValidator([
//                         Validator.required(errorMessage: 'กรุณากรอกรหัสผ่าน'),
//                       ]),
//                       onChanged: (value) {
//                         person = double.tryParse(value);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text('การจองสำเร็จ'),
//                                 content: Text('ขอบคุณที่ใช้บริการ'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder:
//                                               (context) => const AdminPage(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text('ตกลง'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       },

//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFA6C6B),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'ยืนยันการจอง',
//                         style: GoogleFonts.openSans(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Material(
//               color: Color(0xFFF6FBFE),
//               shape: const CircleBorder(),
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 alignment: Alignment.topLeft,
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: const Color(0xFFF6FBFE),
//     );
//   }
// }