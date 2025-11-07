import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_10/core/router/app_router.dart';
import 'package:tp_10/domain/repositories/todo_repository.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';

/// Root widget bootstrapping dependencies and router.
class TodoApp extends StatefulWidget {
  const TodoApp({required this.todoRepository, super.key});

  final TodoRepository todoRepository;

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late final TodoCubit _todoCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _todoCubit = TodoCubit(widget.todoRepository);
    _appRouter = AppRouter(_todoCubit);
  }

  @override
  void dispose() {
    _todoCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _todoCubit,
      child: MaterialApp.router(
        title: 'Todo Cubit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
