import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (error) {
      print("Error signing in: $error");
      return null;
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      DocumentSnapshot userDocument =
          await _firestore.collection('users').doc(uid).get();
      return userDocument;
    } catch (error) {
      print("Error getting user data: $error");
      throw error;
    }
  }
}
