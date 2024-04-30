import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_bubble.dart';
import 'package:minimal_chat_app/components/my_textfield.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //! Text Controller (là nơi lưu tạm tin nhắn người dùng nhập)
  final TextEditingController _messageController = TextEditingController();

  //! Sử dụng lớp AuthService và ChatService
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  //! For TextField focus
  FocusNode myFocusNode = FocusNode();
  //
  @override
  void initState() {
    super.initState();
    // Add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Cause a delay so that the keyboard has time to show up
        // Then the amount of remaining space will be calculated
        // Then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    // Wait a bit for ListView to be build, then scroll to the bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //! Scroll Controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //! Xử lý gửi tin nhắn
  void sendMessage() async {
    // If is there something inside of TextField
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // After send, we must clear data in TextField
      _messageController.clear();
    }
    // Just scroll down auto to view new message
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
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
      stream: _chatService.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Kiểm tra gói tin này có phải là của người dùng hiện tại, tức người gửi hay ko?
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Căn bên phải, nếu người gửi là người dùng hiện tại, và ngược lại
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: data['message'],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  // Build message user
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 50,
        top: 30,
      ),
      child: Row(
        children: [
          // TextField should take of most the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type a messages.',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
