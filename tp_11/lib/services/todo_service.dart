// lib/services/todo_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoService {
  final http.Client client;
  final String baseUrl; // ex: "http://10.0.2.2:3000"

  TodoService({required this.client, required this.baseUrl});

  Future<List<Todo>> getTodos() async {
    final uri = Uri.parse('$baseUrl/todos');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      return body.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load todos (${response.statusCode})');
    }
  }
}
