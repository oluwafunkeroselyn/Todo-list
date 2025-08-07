import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/controller.dart';
import 'package:to_do_app/model.dart';

class TodoScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  final TextEditingController textController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("To-do App"),
        actions: [
          Obx(() => controller.isSaving.value
              ? const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(child: Text("Saving...")),
                )
              : const SizedBox()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final title = textController.text.trim();
                    if (title.isNotEmpty) {
                      controller.createTodo(
                        Todo(
                          userId: 1,
                          id: 0,
                          title: title,
                          isCompleted: false,
                        ),
                      );
                      textController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return controller.todoList.isEmpty
                  ? const Center(child: Text('No todos yet.'))
                  : ListView.builder(
                      itemCount: controller.todoList.length,
                      itemBuilder: (context, index) {
                        final todo = controller.todoList[index];
                        return ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (val) {
                              final updatedTodo = Todo(
                                userId: todo.userId,
                                id: todo.id,
                                title: todo.title,
                                isCompleted: val ?? false,
                              );
                              controller.updateTodoStatus(updatedTodo);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteTodo(todo.id),
                          ),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}
