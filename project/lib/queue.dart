import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          fit: BoxFit.cover,
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          'IT BBQ',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        backgroundColor: const Color(0xFFFA6C6B),
      ),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docRef.snapshots(), // ✅ ตามดูเอกสารนี้แบบเรียลไทม์
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text('ไม่พบคิวของคุณ'));
          }

          final data = snap.data!.data()!;
          final name = data['username']?.toString() ?? '-';
          final people = data['people']?.toString() ?? '-';
          // timestamp อาจเป็น null ชั่วคราวจน serverTimestamp เขียนเสร็จ
          final ts = data['timestamp'];
          String tsText = '-';
          if (ts is Timestamp) {
            final d = ts.toDate();
            tsText =
                '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
                '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
                      rowItem('วันเวลาที่จอง', tsText),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA6C6B),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'กลับ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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
}
