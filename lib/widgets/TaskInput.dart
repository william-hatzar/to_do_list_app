import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskInputSection extends StatelessWidget {
  final TextEditingController todoTextController;
  final bool isChecked;
  final Function() addTaskCallback;
  final Function(bool) toggleCheckboxCallback;

  TaskInputSection({
    required this.todoTextController,
    required this.isChecked,
    required this.addTaskCallback,
    required this.toggleCheckboxCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 125,
      left: 20,
      right: 20,
      bottom: 20,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  // "Enter" key is pressed, add the task
                  addTaskCallback();
                }
              },
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      toggleCheckboxCallback(value ?? false);
                    },
                  ),
                  // Text
                  Expanded(
                    child: TextField(
                      controller: todoTextController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new task...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Josefin Sans",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
