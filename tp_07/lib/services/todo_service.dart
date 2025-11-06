import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(getUrl()));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Todo> todos = body.map((dynamic item) => Todo.fromJson(item)).toList();
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }

  }

  static String getUrl() {
    var url = dotenv.get("ANDROID_URL_TODOS", fallback: "");
    if (Platform.isIOS) {
      url = dotenv.get("IOS_URL_TODOS", fallback: "");
    }
    return url;
  }
}
