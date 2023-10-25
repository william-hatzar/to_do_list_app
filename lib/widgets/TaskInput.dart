import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskInputSection extends StatelessWidget {
  final TextEditingController todoTextController;
  final bool isChecked;
  final Function() addTaskCallback;
  final Function(bool) toggleCheckboxCallback;
  final bool darkMode;

  TaskInputSection({
    required this.todoTextController,
    required this.isChecked,
    required this.addTaskCallback,
    required this.toggleCheckboxCallback,
    required this.darkMode
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
              color: darkMode ? const Color(0xFF25273D) : Colors.white,
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
                    activeColor: darkMode ? Colors.black : Colors.white,
                    checkColor: darkMode ? Colors.white : Colors.black,// Color for the checked (true) stat// Color for the check icon
                  ),
                  // Text
                  Expanded(
                    child: TextField(
                      controller: todoTextController,
                      decoration: InputDecoration(
                        hintText: 'Create a new todo...',
                        hintStyle: darkMode ? const TextStyle(color: Colors.grey) : const TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black,
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
