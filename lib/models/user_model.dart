class UserModel {
  final String? id;
  final String name;
  final String surname;
  final String username;
  final String identityNumber;
  final String phone;
  final String email;
  final String address;

  UserModel({
    this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.identityNumber,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'],
      surname: data['surname'],
      username: data['username'],
      identityNumber: data['identityNumber'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'username': username,
      'identityNumber': identityNumber,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
