import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';
import 'package:tp_10/presentation/pages/todo_detail_page.dart';
import 'package:tp_10/presentation/pages/todo_form_page.dart';
import 'package:tp_10/presentation/pages/todo_list_page.dart';

/// Centralised router using GoRouter for declarative navigation.
class AppRouter {
  AppRouter(this._todoCubit);

  final TodoCubit _todoCubit;

  late final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const TodoListPage(),
        routes: <RouteBase>[
          GoRoute(
            path: 'todo/new',
            builder: (context, state) => const TodoFormPage(),
          ),
          GoRoute(
            path: 'todo/:id',
            builder: (context, state) {
              final todo = _resolveTodo(state);
              if (todo == null) {
                return const _NotFoundPage();
              }
              return TodoDetailPage(todo: todo);
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final todo = _resolveTodo(state);
                  if (todo == null) {
                    return const _NotFoundPage();
                  }
                  return TodoFormPage(initialTodo: todo);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        _NotFoundPage(message: state.error.toString()),
  );

  Todo? _resolveTodo(GoRouterState state) {
    if (state.extra is Todo) {
      return state.extra! as Todo;
    }
    final id = int.tryParse(state.pathParameters['id'] ?? '');
    if (id == null) {
      return null;
    }
    try {
      return _todoCubit.state.todos.firstWhere((todo) => todo.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Basic not-found screen for invalid routes or data.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Introuvable')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Oups, impossible de trouver cette page.'),
            if (message != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(message!),
            ],
          ],
        ),
      ),
    );
  }
}
