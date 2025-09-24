// main.dart
import 'package:flutter/material.dart';

void main() => runApp(const ITBBQApp());

class ITBBQApp extends StatelessWidget {
  const ITBBQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5FAFF), // พื้นหลังฟ้าอ่อนเหมือนภาพ
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF26D6D), // โทนคอรัล
          brightness: Brightness.light,
        ),
      ),
      home: const ITBBQDashboard(),
    );
  }
}

class ITBBQDashboard extends StatefulWidget {
  const ITBBQDashboard({super.key});

  @override
  State<ITBBQDashboard> createState() => _ITBBQDashboardState();
}

class _ITBBQDashboardState extends State<ITBBQDashboard> {
  String currentNumber = 'A001';
  int waiting = 12;
  final List<String> nextTickets =
      List.generate(10, (i) => 'A${(i + 2).toString().padLeft(3, "0")}'); // A002..A011

  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final coral = const Color(0xFFF26D6D);
    final cream = const Color(0xFFF6EDE3);
    final green = const Color(0xFF6BBF59);
    final pink = const Color(0xFFF8C1C1);
    final chipBg = const Color(0xFFEDE7E1);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // ===== Header แบบภาพตัวอย่าง =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 86,
              color: coral,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'IT BBQ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== การ์ด คิวปัจจุบัน + รอทั้งหมด =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('คิวปัจจุบัน',
                              style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currentNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 36,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.people_alt_outlined, size: 18),
                              SizedBox(width: 6),
                              Text('รอทั้งหมด'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$waiting',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== ปุ่ม เรียกถัดไป / ข้าม =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _callNext,
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('เรียกคิวถัดไป',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: pink,
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.black.withOpacity(.15)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _skip,
                      icon: const Icon(Icons.skip_next),
                      label: const Text('ข้าม',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== คิวถัดไป (หัวเรื่อง + จำนวน) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('คิวถัดไป',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('${nextTickets.length} รายการ',
                            style: TextStyle(
                                color: Colors.black.withOpacity(.55))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: nextTickets.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                nextTickets[i],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== Bottom bar 2 ปุ่ม =====
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), label: ''),
        ],
        selectedIndex: bottomIndex,
        onDestinationSelected: (i) => setState(() => bottomIndex = i),
      ),
    );
  }

  void _callNext() {
    setState(() {
      // ดันปัจจุบันออกไปเป็นตัวแรกของ next แล้วเลื่อน
      if (nextTickets.isNotEmpty) {
        currentNumber = nextTickets.first;
        nextTickets.removeAt(0);
        // จำลองเพิ่มคิวท้ายแถว
        final last = int.parse(currentNumber.substring(1));
        nextTickets.add('A${(last + nextTickets.length + 1).toString().padLeft(3, "0")}');
        waiting = nextTickets.length;
      }
    });
  }

  void _skip() {
    setState(() {
      // ข้าม = ส่ง current ไปท้ายแถว แล้วดึงตัวถัดไปขึ้นมา
      nextTickets.add(currentNumber);
      currentNumber = nextTickets.first;
      nextTickets.removeAt(0);
      waiting = nextTickets.length;
    });
  }
}

/// การ์ดโค้ง + เงาอ่อนเหมือนภาพ
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
