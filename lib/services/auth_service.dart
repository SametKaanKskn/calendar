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
      print("Oturum açilirken hata oluştu: $error");
      return null;
    }
  }

  Future<User?> signInAsAdmin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot userDocument =
          await _firestore.collection('users').doc(result.user!.uid).get();
      if (userDocument.exists) {
        Map<String, dynamic> data = userDocument.data() as Map<String, dynamic>;
        if (data['userTypes'] == 'Admin') {
          return result.user;
        } else {
          print("Kullanıcı admin değil");
          return null;
        }
      } else {
        print("Kullanıcı bulunamadı");
        return null;
      }
    } catch (error) {
      print("Oturum açılırken hata oluştu: $error");
      return null;
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      DocumentSnapshot userDocument =
          await _firestore.collection('users').doc(uid).get();
      return userDocument;
    } catch (error) {
      print("Kullanıcı verileri alınırken hata oluştu: $error");
      throw error;
    }
  }
}
