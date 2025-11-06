import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tp_10/data/models/todo_model.dart';

part 'todo_service.g.dart';

/// Retrofit contract encapsulating the REST API dedicated to todos.
@RestApi()
abstract class TodoService {
  factory TodoService(Dio dio, {String baseUrl}) = _TodoService;

  @GET('')
  Future<List<TodoModel>> fetchTodos();

  @GET('/{id}')
  Future<TodoModel> fetchTodo(@Path('id') int id);

  @POST('')
  Future<TodoModel> createTodo(@Body() TodoModel todo);

  @PUT('/{id}')
  Future<TodoModel> updateTodo(@Path('id') int id, @Body() TodoModel todo);

  @DELETE('/{id}')
  Future<void> deleteTodo(@Path('id') int id);
}
