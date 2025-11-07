import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';
import 'package:tp_10/presentation/cubit/todo_state.dart';

/// Form page used for both creation and edition of a todo.
class TodoFormPage extends StatefulWidget {
  const TodoFormPage({this.initialTodo, super.key});

  final Todo? initialTodo;

  bool get isEditing => initialTodo != null;

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.initialTodo;
    _titleController = TextEditingController(text: todo?.title ?? '');
    _descriptionController = TextEditingController(
      text: todo?.description ?? '',
    );
    _isCompleted = todo?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier la tâche' : 'Nouvelle tâche'),
      ),
      body: BlocListener<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le titre est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  CheckboxListTile(
                    value: _isCompleted,
                    title: const Text('Terminée'),
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submit(context),
                      child: Text(widget.isEditing ? 'Mettre à jour' : 'Créer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cubit = context.read<TodoCubit>();
    final router = GoRouter.of(context);

    final todo = Todo(
      id: widget.initialTodo?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: _isCompleted,
    );

    await cubit.saveTodo(todo);
    router.pop();
  }
}
