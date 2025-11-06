import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tp_08/pages/todo_list_page.dart';
import 'package:tp_08/services/todo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final apiBaseUrl = dotenv.env['ANDROID_URL_TODOS'] ?? '';

  final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

  final todoService = TodoService(dio, baseUrl: apiBaseUrl);

  runApp(TodoApp(todoService: todoService));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.todoService});

  final TodoService todoService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrofit Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TodoListPage(todoService: todoService),
    );
  }
}
