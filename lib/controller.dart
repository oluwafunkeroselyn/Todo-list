import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/model.dart';
import 'package:to_do_app/api_services.dart';

class TodoController extends GetxController {
  var todoList = <Todo>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs; // 🔹 NEW: tracks saving state
  final textController = TextEditingController(); // 🔹 NEW: for dialog input

  final ApiServices apiServices = ApiServices();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() async {
    isLoading.value = true;
    try {
      var todos = await apiServices.fetchTodos();
      todoList.assignAll(todos);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void createTodoFromText() async {
    final title = textController.text.trim();
    if (title.isEmpty) return;

    isSaving.value = true; // 🔹 Start saving
    try {
      Todo newTodo = Todo(
        id: 0, // Replace with appropriate logic if your API generates ID
        title: title,
        isCompleted: false, userId: 1,
        
      );
      var createdTodo = await apiServices.createTodo(newTodo);
      todoList.insert(0, createdTodo);
      textController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create todo');
    } finally {
      isSaving.value = false; // 🔹 End saving
    }
  }

  void createTodo(Todo todo) async {
    isSaving.value = true;
    try {
      var newTodo = await apiServices.createTodo(todo);
      todoList.insert(0, newTodo);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create todo');
    } finally {
      isSaving.value = false;
    }
  }

  void updateTodoStatus(Todo todo) async {
    try {
      var updatedTodo = await apiServices.updateTodo(todo.id.toString(), todo);
      int index = todoList.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todoList[index] = updatedTodo;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update todo');
    }
  }

  void deleteTodo(int id) async {
    try {
      await apiServices.deleteTodo(id.toString());
      todoList.removeWhere((todo) => todo.id == id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete todo');
    }
  }

  @override
  void onClose() {
    textController.dispose(); // 🔹 Dispose controller to avoid memory leaks
    super.onClose();
  }
}
