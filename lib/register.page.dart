import 'package:calendar/models/user_model.dart';
import 'package:calendar/services/auth_service.dart';
import 'package:calendar/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _username = '';
  String _password = '';
  String _identityNumber = '';
  String _phone = '';
  String _email = '';
  String _address = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        UserModel newUser = UserModel(
          name: _name,
          surname: _surname,
          username: _username,
          identityNumber: _identityNumber,
          phone: _phone,
          email: _email,
          address: _address,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set(newUser.toMap());

        print('Kullanıcı başarıyla kaydedildi!');
      } on FirebaseAuthException catch (e) {
        print('Hata: $e');
      } catch (e) {
        print('Hata: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kayıt Ol'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/register.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 16.0),
                    Wrap(
                      spacing: 8,
                      runSpacing: 16,
                      children: [
                        _buildTextFormField('Ad', (value) {
                          setState(() {
                            _name = value;
                          });
                        }),
                        _buildTextFormField('Soyad', (value) {
                          setState(() {
                            _surname = value;
                          });
                        }),
                        _buildTextFormField('Kullanıcı Adı', (value) {
                          setState(() {
                            _username = value;
                          });
                        }),
                        _buildTextFormField('Şifre', (value) {
                          setState(() {
                            _password = value;
                          });
                        }, isPassword: true),
                        _buildTextFormField('TC Kimlik No', (value) {
                          setState(() {
                            _identityNumber = value;
                          });
                        }, keyboardType: TextInputType.number),
                        _buildTextFormField('Telefon', (value) {
                          setState(() {
                            _phone = value;
                          });
                        }, keyboardType: TextInputType.phone),
                        _buildTextFormField('E-posta Adresi', (value) {
                          setState(() {
                            _email = value;
                          });
                        }, keyboardType: TextInputType.emailAddress),
                        _buildTextFormField('Adres', (value) {
                          setState(() {
                            _address = value;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary:
                            Theme.of(context).primaryColor.withOpacity(0.7),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String labelText, Function(String) onChanged,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[150],
          contentPadding: EdgeInsets.all(16),
        ),
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen $labelText girin';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
