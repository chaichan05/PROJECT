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
        title: Text(
          'Admin Queue',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        backgroundColor: const Color(0xFFFA6C6B),
        automaticallyImplyLeading: false, // ไม่ให้แสดงปุ่ม back
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

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index].data()!;
              final userId = users[index].id;
              final username = data['username'] ?? '-';
              final queue = data['queteue']?.toString() ?? '-';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('คิว: $queue'),
                  subtitle: Text('ผู้จอง: $username'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      try {
                        // เรียกคิวสำหรับผู้ใช้คนนี้
                        await _callQueue(userId);

                        // ไม่ต้องไปแสดง dialog หรือหน้าใหม่
                        // ผู้ใช้จะเห็น Dialog ในหน้า "คิวของฉัน" ของตนเองเมื่อถึงคิว
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
          );
        },
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }

  Future<void> _callQueue(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // อัปเดตข้อมูลใน Firestore ให้ผู้ใช้ทราบว่า "ถึงคิว"
      await userRef.update({
        'status': 'ถึงคิวแล้ว',  // เพิ่ม field 'status' ที่จะเก็บข้อความหรือสถานะ
        'notified': true, // Flag ว่ามีการแจ้งเตือนแล้ว
      });
    } catch (e) {
      // หากเกิดข้อผิดพลาด
      throw Exception('ไม่สามารถอัปเดตสถานะผู้ใช้ได้: $e');
    }
  }
}
