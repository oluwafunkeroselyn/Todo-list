import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'todo_controller.dart';

class CreateTodo extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TodoController controller = Get.find();

  CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => controller.update(),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final isSaving = controller.isSaving.value;
              final isEmpty = titleController.text.trim().isEmpty;

              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(45),
                ),
                icon: const Icon(Icons.save),
                label: Text(isSaving ? 'Saving...' : 'Create Todo'),
                onPressed: isSaving || isEmpty
                    ? null
                    : () {
                        controller.textController.text =
                            titleController.text.trim();
                        controller.createTodoFromText();
                        titleController.clear();
                        Get.back();
                      },
              );
            }),
          ],
        ),
      ),
    );
  }
}
