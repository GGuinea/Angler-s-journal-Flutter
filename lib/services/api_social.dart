import 'dart:convert';

import 'package:notatinik_wedkarza/models/post_message.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:http/http.dart';

class ApiSocial {
  final String apiUrl = "https://fishing-diary-backend.herokuapp.com/api";
  var roles = ["user"];

  Future<bool> makePing() async {
    Response res = await post(
      '$apiUrl/ping',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<Response> createUser(
      String username, String email, String password) async {
    Map data = {
      'name': username,
      'username': username,
      'email': email,
      'password': password,
      'role': roles
    };
    Response response = await post(
      '$apiUrl/auth/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<Response> loginUser(String username, String password) async {
    Map data = {
      'username': username,
      'password': password,
    };
    Response response = await post(
      '$apiUrl/auth/signin',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print(response.body);
    print(response.statusCode);
    return response;
  }

  Future<List<String>> getFriendList(User userInfo) async {
    Response response = await get(
      '$apiUrl/friend/getFriends/' + userInfo.userName,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
    );
    List<String> entries = [];
    if (response.statusCode == 200) {
      print(response.body);
      final jsonDecoded = json.decode(utf8.decode(response.bodyBytes));
      for (var jsonObject in jsonDecoded) {
        entries.add(jsonObject);
      }
    }
    return entries;
  }

  Future<Response> postMessage(
      User userInfo, String content, bool isMarker) async {
    String date = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString();
    String time =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    Map data = {
      'content': content,
      'posterName': userInfo.userName,
      'date': date,
      'time': time,
      'isMarker': isMarker
    };
    print(data);
    Response response = await post(
      '$apiUrl/postMessage/addPost',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + userInfo.token,
      },
      body: jsonEncode(data),
    );
    print(response.body);
    print(response.statusCode);
    return response;
  }

  Future<Response> removeFriend(User userInfo, String friendName) async {
    Map data = {'friendName': friendName};
    Response response = await post(
      '$apiUrl/friend/removeFriend/' + userInfo.userName,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + userInfo.token,
      },
      body: jsonEncode(data),
    );
    print(response.body);
    print(response.statusCode);
    return response;
  }

  Future<int> addFriend(User userInfo, String friendName) async {
    Map data = {'friendName': friendName};
    Response response = await post(
      '$apiUrl/friend/addFriend/' + userInfo.userName,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + userInfo.token,
      },
      body: jsonEncode(data),
    );
    print(response.body);
    print(response.statusCode);
    return response.statusCode;
  }

  Future<List<PostMessage>> getMessages(User userInfo) async {
    Response response = await get(
      '$apiUrl/postMessage/getPosts/' + userInfo.userName,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
    );
    List<PostMessage> entries = [];
    if (response.statusCode == 200) {
      print(response.body);
      final jsonDecoded = json.decode(utf8.decode(response.bodyBytes));
      for (var jsonObject in jsonDecoded) {
        entries.add(PostMessage.fromJson(jsonObject));
      }
    }
    return entries;
  }
}
