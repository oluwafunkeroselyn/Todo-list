import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class ApiServices {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Todo>> fetchTodos({int limit = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/todos?_limit=$limit'));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      // API returns dummy data, so we just use our original todo
      final data = jsonDecode(response.body);
      return todo.copyWith(id: data['id'] ?? todo.id);
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<Todo> updateTodoStatusOnly(int id, bool isCompleted) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'completed': isCompleted}),
    );

    if (response.statusCode == 200) {
      // Keep title unchanged, only update completion status
      return Todo(
        id: id,
        title: '', // We'll replace it in controller
        isCompleted: isCompleted,
        userId: 1,
      );
    } else {
      throw Exception('Failed to update status');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
