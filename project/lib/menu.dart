import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

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
      title: 'IT BBQ',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage2(),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      final index = cart.indexWhere((e) => e['name'] == item['name']);
      if (index >= 0) {
        cart[index]['qty'] += 1;
      } else {
        cart.add({...item, 'qty': 1});
      }
    });
  }

  void removeFromCart(String name) {
    setState(() {
      final index = cart.indexWhere((e) => e['name'] == name);
      if (index >= 0) {
        if (cart[index]['qty'] > 1) {
          cart[index]['qty'] -= 1;
        } else {
          cart.removeAt(index);
        }
      }
    });
  }

  void clearCart() {
    setState(() => cart.clear());
  }

  int get totalQuantity =>
      cart.fold(0, (sum, item) => sum + (item['qty'] as int));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.red,
              tabs: [
                Tab(icon: Icon(Icons.food_bank), text: "อาหาร"),
                Tab(icon: Icon(Icons.grass), text: "ผัก"),
                Tab(icon: Icon(Icons.icecream), text: "ของหวาน"),
                Tab(icon: Icon(Icons.local_drink), text: "เครื่องดื่ม"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FirestoreListPage(
                    collectionName: 'food',
                    emptyMessage: "ยังไม่มีข้อมูลอาหาร",
                    onAdd: addToCart,
                  ),
                  FirestoreListPage(
                    collectionName: 'vegetable',
                    emptyMessage: "ยังไม่มีข้อมูลผัก",
                    onAdd: addToCart,
                  ),
                  FirestoreListPage(
                    collectionName: 'dessert',
                    emptyMessage: "ยังไม่มีข้อมูลของหวาน",
                    onAdd: addToCart,
                  ),
                  FirestoreListPage(
                    collectionName: 'drink',
                    emptyMessage: "ยังไม่มีข้อมูลเครื่องดื่ม",
                    onAdd: addToCart,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            totalQuantity > 0
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 20), // ✅ ขยับขึ้น 20px
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: const Offset(0, 6), // ✅ เงาทิศทางด้านล่าง
                            ),
                          ],
                        ),
                        child: FloatingActionButton(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 32,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => CartPage(
                                      cart: cart,
                                      onRemove: removeFromCart,
                                      onClear: clearCart,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            "$totalQuantity",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : null,
      ),
    );
  }
}

class FirestoreListPage extends StatelessWidget {
  final String collectionName;
  final String emptyMessage;
  final Function(Map<String, dynamic>) onAdd;

  const FirestoreListPage({
    super.key,
    required this.collectionName,
    required this.emptyMessage,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        final docs = snapshot.data!.docs;

        // กันข้อมูลซ้ำ (ชื่อซ้ำ)
        final Set<String> seenNames = {};
        final filteredDocs =
            docs.where((doc) {
              final name = doc['name']?.toString() ?? '';
              if (seenNames.contains(name)) {
                return false;
              } else {
                seenNames.add(name);
                return true;
              }
            }).toList();

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;

            final name = data['name']?.toString() ?? "ไม่มีชื่อ";
            final desc = data['description']?.toString() ?? "";
            final price = data['price'] ?? 0;

            // ใช้ collectionName ตรง ๆ เป็น key
            final Map<String, List<String>> categoryImageMap = {
              'food': [
                'assets/food/food1.jpg',
                'assets/food/food2.jpg',
                'assets/food/food3.jpg',
                'assets/food/food4.jpg',
                'assets/food/food5.jpg',
                'assets/food/food6.jpg',
                'assets/food/food7.jpg',
                'assets/food/food8.jpg',
                'assets/food/food9.jpg',
                'assets/food/food10.jpg',
                'assets/food/food11.jpg',
                'assets/food/food12.jpg',
              ],
              'vegetable': [
                'assets/vegetable/vegetable1.jpg',
                'assets/vegetable/vegetable2.jpg',
                'assets/vegetable/vegetable3.jpg',
                'assets/vegetable/vegetable4.jpg',
                'assets/vegetable/vegetable5.jpg',
                'assets/vegetable/vegetable6.jpg',
                'assets/vegetable/vegetable7.jpg',
                'assets/vegetable/vegetable8.jpg',
                'assets/vegetable/vegetable9.jpg',
                'assets/vegetable/vegetable10.jpg',
              ],
              'dessert': [
                'assets/dessert/dessert1.jpg',
                'assets/dessert/dessert2.jpg',
                'assets/dessert/dessert3.jpg',
                'assets/dessert/dessert4.jpg',
                'assets/dessert/dessert5.jpg',
                'assets/dessert/dessert6.jpg',
                'assets/dessert/dessert7.jpg',
                'assets/dessert/dessert8.jpg',
                'assets/dessert/dessert9.jpg',
                'assets/dessert/dessert10.jpg',
                'assets/dessert/dessert11.jpg',
                'assets/dessert/dessert12.jpg',
              ],
              'drink': [
                'assets/drink/drink1.jpg',
                'assets/drink/drink2.jpg',
                'assets/drink/drink3.jpg',
                'assets/drink/drink4.jpeg',
                'assets/drink/drink5.jpg',
                'assets/drink/drink6.jpeg',
                'assets/drink/drink7.jpg',
                'assets/drink/drink8.jpg',
                'assets/drink/drink9.jpg',
                'assets/drink/drink10.png',
              ],
            };

            final imageList = categoryImageMap[collectionName] ?? [];
            String assetImagePath;

            if (index < imageList.length) {
              assetImagePath =
                  imageList[index]; // ✅ ใช้ index ตาม collection นี้
            } else {
              assetImagePath =
                  imageList.isNotEmpty
                      ? imageList.last
                      : 'assets/food/food1.jpg'; // fallback
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // ✅ มุมโค้งมน
              ),
              elevation: 5, // ✅ ใส่เงาให้การ์ด
              shadowColor: Colors.red.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // ✅ มุมโค้งรูปภาพ
                  child: Image.asset(
                    assetImagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$desc • ราคา: $price บาท"),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                  onPressed:
                      () => onAdd({
                        "name": name,
                        "price": price,
                        "image": assetImagePath,
                      }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(String) onRemove;
  final Function() onClear;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final items = cart;

    final totalPrice = items.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("ตะกร้าของฉัน")),
      body:
          items.isEmpty
              ? const Center(child: Text("ยังไม่มีสินค้าในตะกร้า"))
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final imagePath = item['image'];

                  Widget leadingImage;
                  if (imagePath != null && imagePath.startsWith('assets/')) {
                    leadingImage = Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    );
                  } else if (imagePath != null) {
                    leadingImage = Image.network(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    );
                  } else {
                    leadingImage = const Icon(Icons.image_not_supported);
                  }

                  return ListTile(
                    leading: leadingImage,
                    title: Text(item['name']),
                    subtitle: Text(
                      "จำนวน: ${item['qty']} • ราคา: ${item['price']} บาท",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => onRemove(item['name']),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          items.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 8, // ✅ เงาปุ่ม
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.check, size: 22),
                  label: Text(
                    "ยืนยันการสั่งอาหาร (รวม $totalPrice บาท)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.check,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "สั่งอาหารเรียบร้อยแล้ว!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    onClear();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("ตกลง",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              )
              : null,
    );
  }
}
