import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/menu.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);

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
           automaticallyImplyLeading: false, // ไม่ให้แสดงปุ่ม back
        ),
       
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('ไม่พบคิวของคุณ'));
          }

          final data = snapshot.data!.data()!;
          final name = data['username']?.toString() ?? '-';
          final people = data['people']?.toString() ?? '-';
          final queue = data['queteue']?.toString() ?? '-';
          final status =
              data['status'] ?? 'รอต่อไป'; // ใช้ 'status' สำหรับการตรวจสอบ
          final timestamp = data['timestamp'];

          String timestampText = '-';
          if (timestamp is Timestamp) {
            final d = timestamp.toDate();
            timestampText =
                '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
                '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
          }

          // เมื่อ status เป็น "ถึงคิวแล้ว" ให้แสดง Dialog แจ้งเตือน
          if (status == 'ถึงคิวแล้ว') {
            Future.delayed(Duration.zero, () {
              _showDialog(context);
            });
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'คิวของฉัน',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      rowItem('ชื่อผู้จอง', name),
                      rowItem('จำนวนคน', people),
                      rowItem('หมายเลขคิว', queue),
                      rowItem('สถานะ', status),
                      rowItem('วันเวลาที่จอง', timestampText),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: const Color(0xFFF6FBFE),
    );
  }

  // helper แสดงแถวหัวข้อ : ค่า (ขวา)
  Widget rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันแสดง Dialog เมื่อถึงคิว
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ถึงคิวของคุณแล้ว!'),
          content: const Text('คิวของคุณได้มาถึงแล้ว โปรดไปรับบริการได้เลย'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuPage()),
                  );
                }); // ปิด Dialog
              },
              child: const Text('ตกลง', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
