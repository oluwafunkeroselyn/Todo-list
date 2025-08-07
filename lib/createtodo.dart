import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/controller.dart';
import 'package:to_do_app/model.dart';

class CreateTodo extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TodoController controller = Get.find();

  CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
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
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(45),
              ),
              icon: const Icon(Icons.save),
              label: controller.isSaving.value
                  ? const Text('Saving...')
                  : const Text('Create Todo'),
              onPressed: controller.isSaving.value
                  ? null
                  : () {
                      final title = titleController.text.trim();
                      if (title.isNotEmpty) {
                        controller.createTodo(
                          Todo(
                            userId: 1,
                            id: 0, // Server handles ID
                            title: title,
                            isCompleted: false,
                          ),
                        );
                        Get.back();
                      } else {
                        Get.snackbar('Error', 'Please enter a title');
                      }
                    },
            )),
          ],
        ),
      ),
    );
  }
}
