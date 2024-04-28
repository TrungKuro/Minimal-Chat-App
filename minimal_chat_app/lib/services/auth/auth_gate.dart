import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/services/auth/login_or_register.dart';
import 'package:minimal_chat_app/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //! Người dùng đã đăng nhập (Login)
          if (snapshot.hasData) {
            return HomePage();
          }
          //! Người dùng chưa đăng nhập (NOT Login)
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
