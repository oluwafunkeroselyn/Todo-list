import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'api_services.dart';
import 'model.dart';

class TodoController extends GetxController {
  final ApiServices api = ApiServices();
  final box = GetStorage();

  var todoList = <Todo>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFromLocal();
    fetchTodos();
  }

  void loadFromLocal() {
    final stored = box.read<List>('todos');
    if (stored != null) {
      todoList.assignAll(
        stored.map((e) => Todo.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
    }
  }

  void saveToLocal() {
    box.write('todos', todoList.map((t) => t.toJson()).toList());
  }

  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      final list = await api.fetchTodos(limit: 10);
      todoList.assignAll(list);
      saveToLocal();
    } catch (e) {
      Get.snackbar(
        'Offline Mode',
        'Loaded from local storage',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTodoFromText() async {
    final title = textController.text.trim();
    if (title.isEmpty) return;

    isSaving.value = true;
    try {
      final newTodo = Todo(title: title, isCompleted: false, userId: 1);
      final created = await api.createTodo(newTodo);
      todoList.insert(0, created.copyWith(title: title));
      saveToLocal();
      textController.clear();
    } catch (e) {
      todoList.insert(0, Todo(title: title, isCompleted: false, userId: 1));
      saveToLocal();
      Get.snackbar(
        'Offline Mode',
        'Todo saved locally',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateTodoStatus(Todo todo) async {
    try {
      final idx = todoList.indexWhere((t) => t.id == todo.id);
      if (idx == -1) return;

      final updatedLocal = todo.copyWith(isCompleted: !todo.isCompleted);
      todoList[idx] = updatedLocal;
      saveToLocal();

      await api.updateTodoStatusOnly(
        updatedLocal.id ?? 1,
        updatedLocal.isCompleted,
      );
    } catch (e) {
      Get.snackbar(
        'Offline Mode',
        'Change saved locally',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      todoList.removeWhere((t) => t.id == id);
      saveToLocal();
      await api.deleteTodo(id);
    } catch (e) {
      Get.snackbar(
        'Offline Mode',
        'Todo removed locally',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearAllTodos() {
    todoList.clear();
    saveToLocal();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
