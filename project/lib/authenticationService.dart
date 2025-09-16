import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // สมัครสมาชิก
  Future<bool> register(String name, String password) async {
    try {
      final email = "$name@bbq.com"; // ใช้ชื่อเป็น email
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  // ล็อกอิน
  Future<bool> login(String name, String password) async {
    try {
      final email = "$name@bbq.com";
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  // ออกจากระบบ
  Future<void> logout() async {
    await _auth.signOut();
  }

  // คืนชื่อผู้ใช้ปัจจุบัน
  String? currentUserName() {
    final email = _auth.currentUser?.email;
    if (email == null) return null;
    return email.split("@").first; // ตัดเอาเฉพาะชื่อ
  }
}
