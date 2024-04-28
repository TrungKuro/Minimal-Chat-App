import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//! Lớp (ko có UI) - Các dịch vụ xác thực
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* ----------------------------------------------------------------------- */

  //! Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //! Sign in (Login)
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      // Xác thực người dùng
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Lưu thông tin người dùng trong một tài liệu riêng biệt
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //! Sign up (Register)
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      // Xác thực người dùng
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Lưu thông tin người dùng trong một tài liệu riêng biệt
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //! Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //! Errors
}
