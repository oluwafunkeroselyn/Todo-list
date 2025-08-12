class Todo {
  final int? userId;
  final int? id;
  final String title;
  final bool isCompleted;

  Todo({
    this.userId,
    this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        userId: json['userId'] is int
            ? json['userId']
            : int.tryParse(json['userId']?.toString() ?? '') ?? 1,
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        title: json['title'] ?? '',
        isCompleted: json['completed'].toString() == 'true',
      );

  Map<String, dynamic> toJson() => {
        'userId': userId ?? 1,
        'id': id,
        'title': title,
        'completed': isCompleted,
      };

  Todo copyWith({
    int? userId,
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
