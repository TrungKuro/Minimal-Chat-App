//! Lớp (ko có UI) - Các dịch vụ chat
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimal_chat_app/models/message.dart';

class ChatService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* ----------------------------------------------------------------------- */

  //! Get User Stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebase.collection("Users").snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            // Go through each individual user
            final user = doc.data();

            // Return User
            return user;
          },
        ).toList();
      },
    );
  }

  //! Send Message
  Future<void> sendMessage(String receiverID, message) async {
    // Get the current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Construct CHAT ROOM ID for the 2 users (sorted to ensure uniqueness)
    // Đây là nơi lưu trữ tất cả tin nhắn giữa 2 người dùng
    List<String> ids = [currentUserID, receiverID];
    // Sắp xếp các ID này (đảm bảo bất kì 2 người nào cũng sẽ có cùng 1 ID)
    ids.sort();

    // Add new message to Database
  }

  //! Get Message
}
