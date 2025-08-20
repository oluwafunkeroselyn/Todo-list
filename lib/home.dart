import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'todo_controller.dart';

class TodoHome extends StatelessWidget {
  final TodoController controller = Get.put(TodoController(), permanent: true);

  TodoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: controller.clearAllTodos,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
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
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.createTodoFromText,
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.todoList.isEmpty) {
                return const Center(child: Text('No todos yet.'));
              }
              return ListView.builder(
                itemCount: controller.todoList.length,
                itemBuilder: (context, index) {
                  final todo = controller.todoList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => controller.updateTodoStatus(todo),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        todo.isCompleted ? 'Completed' : 'Pending',
                        style: TextStyle(
                          color: todo.isCompleted
                              ? Colors.green
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          if (todo.id != null) {
                            controller.deleteTodo(todo.id!);
                          }
                        },
                      ),
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
