class User {
    String name;
    String userName;
    String email;
    String token;
    User({this.token});

    factory User.fromJson(Map<String, dynamic> preparedJson) {
        return User(
            token: preparedJson['token']
        );
    }

}

