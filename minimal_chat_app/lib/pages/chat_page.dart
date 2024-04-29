import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/my_textfield.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  //! Text Controller (là nơi lưu tạm tin nhắn người dùng nhập)
  final TextEditingController _messageController = TextEditingController();

  //! Sử dụng lớp AuthService và ChatService
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  //! Xử lý gửi tin nhắn
  void sendMessage() async {
    // If is there something inside of TextField
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);

      // After send, we must clear data in TextField
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Input message for User
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build messages list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
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
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['message']);
  }

  // Build message user
  Widget _buildUserInput() {
    return Row(
      children: [
        // TextField should take of most the space
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Type a messages.',
            obscureText: false,
          ),
        ),
        // Send button
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward)),
      ],
    );
  }
}
