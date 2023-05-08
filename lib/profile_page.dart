import 'package:calendar/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  ProfileScreen(this.uid);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userData = await _authService.getUserData(widget.uid);
      setState(() {
        _userData = userData.data() as Map<String, dynamic>;
      });
    } catch (error) {
      print("Kullanıcı verileri alınırken hata oluştu: $error");
    }
  }

  Widget _buildProfileCard(String title, String? value, IconData iconData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        subtitle: Text(value ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfileCard('Ad', _userData['name'], Icons.person),
            _buildProfileCard('Soyad', _userData['surname'], Icons.person),
            _buildProfileCard(
                'Kullanıcı Adı', _userData['username'], Icons.account_circle),
            _buildProfileCard('E-posta', _userData['email'], Icons.email),
            _buildProfileCard('Telefon', _userData['phone'], Icons.phone),
            _buildProfileCard('Adres', _userData['address'], Icons.location_on),
          ],
        ),
      ),
    );
  }
}
