import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/domain/repositories/todo_repository.dart';
import 'package:tp_10/presentation/cubit/todo_state.dart';

/// Manages todo operations and exposes them to the UI.
class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repository) : super(TodoState.initial());

  final TodoRepository _repository;

  Future<void> fetchTodos() async {
    emit(state.copyWith(status: TodoStatus.loading, errorMessage: null));
    try {
      final todos = await _repository.loadTodos();
      emit(
        state.copyWith(
          status: TodoStatus.success,
          todos: todos,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> saveTodo(Todo todo) async {
    emit(state.copyWith(status: TodoStatus.saving, errorMessage: null));
    try {
      final persisted = todo.id == null
          ? await _repository.createTodo(todo)
          : await _repository.updateTodo(todo);
      final updatedList = _mergeTodoIntoState(persisted);
      emit(state.copyWith(status: TodoStatus.success, todos: updatedList));
    } catch (error) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> deleteTodo(int id) async {
    emit(state.copyWith(status: TodoStatus.saving, errorMessage: null));
    try {
      await _repository.deleteTodo(id);
      final updatedList = state.todos
          .where((todo) => todo.id != id)
          .toList(growable: false);
      emit(state.copyWith(status: TodoStatus.success, todos: updatedList));
    } catch (error) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  List<Todo> _mergeTodoIntoState(Todo persisted) {
    final hasExisting = state.todos.any((todo) => todo.id == persisted.id);
    if (!hasExisting) {
      return List<Todo>.from(state.todos)..add(persisted);
    }
    return state.todos
        .map((todo) => todo.id == persisted.id ? persisted : todo)
        .toList(growable: false);
  }
}
