import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/my_drawer.dart';
import 'package:minimal_chat_app/components/user_tile.dart';
import 'package:minimal_chat_app/pages/chat_page.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Sử dụng lớp AuthService và ChatService
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(), //!
    );
  }

  // Tạo một danh sách người dùng, ngoại trừ người dùng hiện tại đang đăng nhập
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        //! Error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        //! Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        //! Return List View
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  // Xây dựng ô danh sách riêng cho người dùng
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // Hiển thị tất cả người dùng, ngoại trừ người dùng hiện tại
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverID: userData["uid"],
              ),
            ),
          ); //! Chuyển tới trang chat (CHAT)
        },
      );
    } else {
      return Container();
    }
  }
}
