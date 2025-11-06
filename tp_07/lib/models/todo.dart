class Todo {
  final int? id;
  final int? userId;
  final String title;
  final bool completed;

  Todo({this.id, this.userId, required this.title, this.completed = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }

  String toJson() {
    return '{"id": $id, "userId": $userId, "title": "$title", "completed": $completed}';
  }
}
