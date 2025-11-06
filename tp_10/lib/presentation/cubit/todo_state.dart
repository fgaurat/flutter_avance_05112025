import 'package:equatable/equatable.dart';
import 'package:tp_10/domain/entities/todo.dart';

/// Represents the loading lifecycle for todo operations.
enum TodoStatus { initial, loading, success, failure, saving }

/// Immutable Cubit state capturing todos and transient metadata.
class TodoState extends Equatable {
  const TodoState({
    required this.status,
    required this.todos,
    this.errorMessage,
  });

  factory TodoState.initial() {
    return const TodoState(status: TodoStatus.initial, todos: <Todo>[]);
  }

  final TodoStatus status;
  final List<Todo> todos;
  final String? errorMessage;

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, todos, errorMessage];
}
