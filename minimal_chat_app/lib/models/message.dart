import 'package:cloud_firestore/cloud_firestore.dart';

//! Lớp (ko có UI) - Cấu trúc của một tin nhắn
class Message {
  // Những thông tin ta cần biết trong một tin nhắn
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  // Chuyển đổi sang Map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
