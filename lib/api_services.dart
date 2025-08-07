import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_app/model.dart';

class ApiServices {
  final String baseUrl = 'https://6894f1d3be3700414e14fa08.mockapi.io/oluwafunkeroselyn';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/Todos'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<Todo>((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Todos');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create Todo');
    }
  }

  Future<Todo> updateTodo(String id, Todo todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Todos/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete Todo');
    }
  }
}
