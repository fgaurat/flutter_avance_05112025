import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tp_08/models/todo.dart';

part 'todo_service.g.dart';

@RestApi(parser: Parser.JsonSerializable)
abstract class TodoService {
  factory TodoService(Dio dio, {String baseUrl}) = _TodoService;

  @GET("/")
  Future<List<Todo>> getTodos();
}
