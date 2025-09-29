import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQueuePage extends StatelessWidget {
  const AdminQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');

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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFA6C6B),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: usersRef.orderBy('queteue').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลคิว'));
          }

          final users = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 เพิ่มหัวข้อ "รายชื่อผู้จอง" ตรงกลาง
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "📋 รายชื่อผู้จอง",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // 🔹 ListView ด้านล่าง
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final data = users[index].data()!;
                    final userId = users[index].id;
                    final username = data['username'] ?? '-';
                    final queue = data['queteue']?.toString() ?? '-';
                    final people = data['people']?.toString() ?? '-';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: ListTile(
                        title: Text('คิว: $queue'),
                        subtitle: Text('ผู้จอง: $username\nจำนวน $people'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            try {
                              await _callQueue(userId); //เอาไว้อัพเดท status
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA6C6B),
                          ),
                          child: const Text('เรียกคิว'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }

  Future<void> _callQueue(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    //คือการอ้างอิงไปยังเอกสารผู้ใช้ใน Firestore ที่มี
    try {
      await userRef.update({'status': 'ถึงคิวแล้ว', 'notified': true});
      await userRef.delete();
    } catch (e) {
      throw Exception('ไม่สามารถอัปเดตสถานะผู้ใช้ได้: $e');
    }
  }
}
