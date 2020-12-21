class User {
  String name;
  String userName;
  String email;
  String token;
  String password;
  int id;
  User({this.token, this.email, this.id});

  factory User.fromJson(Map<String, dynamic> preparedJson) {
    return User(
        token: preparedJson['token'],
        email: preparedJson['email'],
        id: preparedJson['userId']);
  }
}
