import 'package:flutter/material.dart';
import 'package:tp_11/app/home_todolist.dart';
import 'package:tp_11/services/todo_service.dart';
import 'package:http/http.dart' as http;

void main() {
  final service = TodoService(
    client: http.Client(),
    baseUrl: "http://10.0.2.2:3000",
  );
  runApp(MyAppTodoList(service: service));
  // runApp(const MyApp());
}

void runAppWithService(TodoService service) {
  runApp(MyAppTodoList(service: service));
}