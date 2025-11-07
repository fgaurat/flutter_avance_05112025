import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tp_10/app.dart';
import 'package:tp_10/core/config/app_config.dart';
import 'package:tp_10/data/repositories/todo_repository_impl.dart';
import 'package:tp_10/data/services/todo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.todosEndpoint,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final todoService = TodoService(dio, baseUrl: AppConfig.todosEndpoint);
  final todoRepository = TodoRepositoryImpl(todoService);

  runApp(TodoApp(todoRepository: todoRepository));
}
