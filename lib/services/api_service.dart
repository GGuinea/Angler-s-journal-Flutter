import 'dart:convert';

import 'package:NotatnikWedkarza/models/FishingEntry.dart';
import 'package:NotatnikWedkarza/models/User.dart';
import 'package:NotatnikWedkarza/models/comment.dart';
import 'package:NotatnikWedkarza/models/district_entry.dart';
import 'package:NotatnikWedkarza/models/fishing_area.dart';
import 'package:http/http.dart';

class ApiService {
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

  Future<List<FishingEntry>> getEntries(User userInfo) async {
    Response response = await get(
      '$apiUrl/data/getEntries/' + userInfo.userName,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
    );
    //print('Authentication Bearer ' + userInfo.token);
    var entries = List<FishingEntry>();
    if (response.statusCode == 200) {
      print(response.body);
      final jsonDecoded = json.decode(response.body);
      for (var jsonObject in jsonDecoded) {
        entries.add(FishingEntry.fromJson(jsonObject));
      }
    }
    return entries;
  }

  Future<Response> addEntry(FishingEntry entry, User userInfo) async {
    Map data = {
      'username': userInfo.userName,
      'title': entry.name,
      'date': entry.dateTime,
      'place': entry.nameOfThePlace,
      'description': entry.description,
      'file': entry.img,
      'methods': entry.methods,
      'fishes': entry.fishes,
      'details': entry.details,
    };
    Response response = await post(
      '$apiUrl/data/addEntry',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
      body: jsonEncode(data),
    );
    //print('Authentication Bearer ' + userInfo.token);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<List<DistrictEntry>> getDistricts(userInfo) async {
    Response response = await get(
      '$apiUrl/area/getDistricts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
    );
    var entries = List<DistrictEntry>();
    if (response.statusCode == 200) {
      print(response.body);
      final jsonDecoded = json.decode(response.body);
      for (var jsonObject in jsonDecoded) {
        entries.add(DistrictEntry.fromJson(jsonObject));
      }
    }
    return entries;
  }

  Future<List<FishingArea>> getAreasFromDistict(userInfo, district) async {
    Response response = await get(
      '$apiUrl/area/getEntries/' + district,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
    );
    var entries = List<FishingArea>();
    if (response.statusCode == 200) {
      print(response.body);
      final jsonDecoded = json.decode(response.body);
      for (var jsonObject in jsonDecoded) {
        entries.add(FishingArea.fromJson(jsonObject));
      }
    } else {
      print(response.statusCode);
    }
    return entries;
  }

  Future<Comment> addComment(
      Comment comment, User userInfo, String areaName) async {
    Map data = {
      'content': comment.content,
      'posterName': comment.posterName,
      'areaName': areaName,
      'date': comment.date,
    };
    Response response = await post(
      '$apiUrl/comment/addComment',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userInfo.token,
      },
      body: jsonEncode(data),
    );
    print(response.statusCode);
    print(response.body);
    final jsonDecoded = await json.decode(response.body);
    Comment newComment = Comment.fromJson(jsonDecoded);
    return newComment;
  }
}
