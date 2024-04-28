//! Lớp (ko có UI) - Các dịch vụ chat
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

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

  //! Get Message
}
