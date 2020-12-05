class User {
  String name;
  String userName;
  String email;
  String token;
  String password;
  User({this.token, this.email});

  factory User.fromJson(Map<String, dynamic> preparedJson) {
    return User(token: preparedJson['token'], email: preparedJson['email']);
  }
}
