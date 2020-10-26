import 'package:http/http.dart';

class ApiService {
  final String apiUrl = "https://fishing-diary-backend.herokuapp.com/api";

  Future<bool> makePing() async {
    print("Uruchamiam");
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
}
