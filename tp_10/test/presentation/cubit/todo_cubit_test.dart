import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/domain/repositories/todo_repository.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';
import 'package:tp_10/presentation/cubit/todo_state.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late TodoRepository repository;

  const todoA = Todo(
    id: 1,
    title: 'Todo A',
    description: 'first todo',
    isCompleted: false,
  );

  const todoB = Todo(
    id: 2,
    title: 'Todo B',
    description: 'second todo',
    isCompleted: true,
  );

  const updatedTodoA = Todo(
    id: 1,
    title: 'Todo A updated',
    description: 'updated todo',
    isCompleted: true,
  );

  const persistedTodo = Todo(
    id: 3,
    title: 'Created',
    description: 'created todo',
    isCompleted: false,
  );

  const fallbackTodo = Todo(
    id: 999,
    title: 'fallback',
    description: 'fallback',
    isCompleted: false,
  );

  setUpAll(() {
    registerFallbackValue(fallbackTodo);
  });

  setUp(() {
    repository = _MockTodoRepository();
  });

  tearDown(() {
    reset(repository);
  });

  group('TodoCubit', () {
    blocTest<TodoCubit, TodoState>(
      'emits loading then success when fetchTodos succeeds',
      setUp: () {
        when(() => repository.loadTodos())
            .thenAnswer((_) async => <Todo>[todoA, todoB]);
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.fetchTodos(),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.loading)
            .having((state) => state.todos, 'todos', isEmpty)
            .having((state) => state.errorMessage, 'error', isNull),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.success)
            .having((state) => state.todos, 'todos', equals(<Todo>[todoA, todoB]))
            .having((state) => state.errorMessage, 'error', isNull),
      ],
      verify: (_) {
        verify(() => repository.loadTodos()).called(1);
      },
    );

    blocTest<TodoCubit, TodoState>(
      'emits loading then failure when fetchTodos throws',
      setUp: () {
        when(() => repository.loadTodos()).thenThrow(Exception('network-error'));
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.fetchTodos(),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.loading)
            .having((state) => state.errorMessage, 'error', isNull),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.failure)
            .having((state) => state.errorMessage, 'error', 'Exception: network-error'),
      ],
    );

    blocTest<TodoCubit, TodoState>(
      'emits saving then success with merged list when creating a todo',
      setUp: () {
        when(() => repository.createTodo(any()))
            .thenAnswer((_) async => persistedTodo);
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.saveTodo(
        const Todo(
          title: 'New',
          description: 'brand new todo',
          isCompleted: false,
        ),
      ),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.saving)
            .having((state) => state.todos, 'todos', isEmpty),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.success)
            .having((state) => state.todos, 'todos', equals(<Todo>[persistedTodo])),
      ],
      verify: (_) {
        verify(() => repository.createTodo(any())).called(1);
      },
    );

    blocTest<TodoCubit, TodoState>(
      'updates the matching todo when saveTodo is called with an id',
      setUp: () {
        when(() => repository.updateTodo(updatedTodoA))
            .thenAnswer((_) async => updatedTodoA);
      },
      build: () => TodoCubit(repository),
      seed: () => const TodoState(
        status: TodoStatus.success,
        todos: <Todo>[todoA, todoB],
      ),
      act: (cubit) => cubit.saveTodo(updatedTodoA),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.saving)
            .having((state) => state.todos, 'todos', equals(<Todo>[todoA, todoB])),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.success)
            .having((state) => state.todos, 'todos', equals(<Todo>[updatedTodoA, todoB])),
      ],
    );

    blocTest<TodoCubit, TodoState>(
      'emits failure when saveTodo throws',
      setUp: () {
        when(() => repository.createTodo(any()))
            .thenThrow(Exception('persist failed'));
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.saveTodo(
        const Todo(
          title: 'broken',
          description: 'should fail',
          isCompleted: true,
        ),
      ),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.saving),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.failure)
            .having(
              (state) => state.errorMessage,
              'error',
              'Exception: persist failed',
            ),
      ],
    );

    blocTest<TodoCubit, TodoState>(
      'removes the todo locally after deleteTodo succeeds',
      setUp: () {
        when(() => repository.deleteTodo(todoA.id!))
            .thenAnswer((_) async {});
      },
      build: () => TodoCubit(repository),
      seed: () => const TodoState(
        status: TodoStatus.success,
        todos: <Todo>[todoA, todoB],
      ),
      act: (cubit) => cubit.deleteTodo(todoA.id!),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.saving)
            .having((state) => state.todos, 'todos', equals(<Todo>[todoA, todoB])),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.success)
            .having((state) => state.todos, 'todos', equals(<Todo>[todoB])),
      ],
      verify: (_) {
        verify(() => repository.deleteTodo(todoA.id!)).called(1);
      },
    );

    blocTest<TodoCubit, TodoState>(
      'emits failure when deleteTodo throws',
      setUp: () {
        when(() => repository.deleteTodo(todoA.id!))
            .thenThrow(Exception('delete failed'));
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.deleteTodo(todoA.id!),
      expect: () => <dynamic>[
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.saving),
        isA<TodoState>()
            .having((state) => state.status, 'status', TodoStatus.failure)
            .having(
              (state) => state.errorMessage,
              'error',
              'Exception: delete failed',
            ),
      ],
    );
  });
}
