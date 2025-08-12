import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_services.dart';
import 'model.dart';

class TodoController extends GetxController {
  final ApiServices api = ApiServices();

  var todoList = <Todo>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      final list = await api.fetchTodos(limit: 10);
      todoList.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTodoFromText() async {
    final title = textController.text.trim();
    if (title.isEmpty) return;

    isSaving.value = true;
    try {
      // Create new Todo object locally
      final newTodo = Todo(
        title: title,
        isCompleted: false,
        userId: 1,
      );

      // Send to API
      final created = await api.createTodo(newTodo);

      // API will return an ID (JSONPlaceholder returns id = 201+), so we just insert
      todoList.insert(0, created.copyWith(title: title));

      textController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create todo: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateTodoStatus(Todo todo) async {
    try {
      final idx = todoList.indexWhere((t) => t.id == todo.id);
      if (idx == -1) return;

      // Keep the same title but toggle the status locally
      final updatedLocal = todo.copyWith(isCompleted: !todo.isCompleted);
      todoList[idx] = updatedLocal;

      // Update status on the API
      final updatedFromApi = await api.updateTodoStatusOnly(
        updatedLocal.id ?? 1,
        updatedLocal.isCompleted,
      );

      // Merge API's returned data with the original title
      todoList[idx] = updatedFromApi.copyWith(title: updatedLocal.title);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update todo: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      // Remove locally
      todoList.removeWhere((t) => t.id == id);

      // Delete from API
      await api.deleteTodo(id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete todo: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
