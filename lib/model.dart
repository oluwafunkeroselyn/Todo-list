class Todo {
  final int userId;
  final int id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'] is int ? json['userId'] : int.tryParse(json['userId'].toString()) ?? 0,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      isCompleted: json['completed'] == true || json['completed'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': isCompleted,
    };
  }

  @override
  String toString() =>
      'Todo{userId: $userId, id: $id, title: $title, isCompleted: $isCompleted}';
}
