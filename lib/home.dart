import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/controller.dart';
import 'package:to_do_app/model.dart'; // Make sure this includes the Todo model

class TodoHome extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  TodoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: [
          // "Saving..." indicator
          if (controller.isSaving.value)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Saving...',
                  style: Get.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Get.isDarkMode
                  ? Get.changeThemeMode(ThemeMode.light)
                  : Get.changeThemeMode(ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return controller.todoList.isEmpty
            ? const Center(child: Text("No Todos yet"))
            : ListView.builder(
                itemCount: controller.todoList.length,
                itemBuilder: (context, index) {
                  final todo = controller.todoList[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        todo.isCompleted
                            ? Icons.check_circle_outlined
                            : Icons.circle_outlined,
                        color: todo.isCompleted ? Colors.teal : Colors.grey,
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        color: Colors.tealAccent,
                        onPressed: () => controller.deleteTodo(todo.id),
                      ),
                      onTap: () {
                        // 🔁 Replace copyWith with manual object creation
                        final updatedTodo = Todo(
                          id: todo.id,
                          title: todo.title,
                          isCompleted: !todo.isCompleted, userId: todo.userId,
                        );
                        controller.updateTodoStatus(updatedTodo);
                      },
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => Get.defaultDialog(
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          contentPadding: const EdgeInsets.all(16),
          title: 'Add Todo',
          content: TextField(
            controller: controller.textController,
            decoration: const InputDecoration(
              labelText: 'Todo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.createTodoFromText(); // ✅ replaces controller.textController.text
                Get.back();
              },
              child: const Text('Add'),
            ),
          ],
        ),
        child: const Icon(Icons.add),
      ),
    ));
  }
}
