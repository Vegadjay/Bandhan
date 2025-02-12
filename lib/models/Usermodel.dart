// class MUser {
//   final int? id;
//   final String fullname;
//   final String username;
//   final String email;
//   final String phoneNumber;
//   final String address;
//   final int age;
//   final String gender;
//   final String proffession;
//   final String cast;
//   final String mStatus;
//   final String country;
//   final String annualIncome;

//   MUser(
//       this.fullname,
//       this.phoneNumber,
//       this.address,
//       this.age,
//       this.gender,
//       this.proffession,
//       this.cast,
//       this.mStatus,
//       this.country,
//       this.annualIncome,
//       {this.id,
//       required this.username,
//       required this.email});

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'username': username, 'email': email};
//   }

//   factory MUser.fromMap(Map<String, dynamic> map) {
//     return MUser(
//       id: map['id'],
//       username: map['username'],
//       email: map['email'],
//     );
//   }
// }
