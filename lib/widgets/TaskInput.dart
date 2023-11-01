import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import "package:to_do_list_app/state/app_state.dart";

class TaskInputSection extends StatefulWidget {
  final TextEditingController todoTextController;
  final bool isChecked;
  final Function() addTaskCallback;
  final Function(bool) toggleCheckboxCallback;

  const TaskInputSection({super.key,
    required this.todoTextController,
    required this.isChecked,
    required this.addTaskCallback,
    required this.toggleCheckboxCallback,
  });

  @override
  State<TaskInputSection> createState() => _TaskInputSectionState();
}

class _TaskInputSectionState extends State<TaskInputSection> {
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Provider.of<AppState>(context).darkMode;
    return Column(
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
                widget.addTaskCallback();
              }
            },
            child: Row(
              children: [
                Checkbox(
                  value: widget.isChecked,
                  onChanged: (bool? value) {
                    widget.toggleCheckboxCallback(value ?? false);
                  },
                  activeColor: darkMode ? Colors.black : Colors.white,
                  checkColor: darkMode ? Colors.white : Colors.black,// Color for the checked (true) stat// Color for the check icon
                ),
                // GestureDetector(
                //   onTap: widget.toggleCheckboxCallback(widget.isChecked),
                //     child: Container(
                //         decoration: BoxDecoration(
                //             gradient: widget.isChecked
                //                 ? const LinearGradient(colors: [
                //                     Colors.red,
                //                     Colors.blue,
                //                     Colors.orange
                //                   ])
                //                 : const LinearGradient(colors: [
                //               Colors.red,
                //               Colors.blue,
                //               Colors.orange
                //             ])),
                //         child: Center(
                //           child: widget.isChecked
                //               ? const Icon(
                //                   Icons.check,
                //                   size: 16,
                //                   color: Colors.blueGrey,
                //                 )
                //               : null,
                //         ))),
                // Text
                Expanded(
                  child: TextField(
                    controller: widget.todoTextController,
                    decoration: InputDecoration(
                      hintText: 'Create a new todo...',
                      hintStyle: darkMode ? const TextStyle(color: Colors.grey) : const TextStyle(color: Colors.blueGrey),
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
    );
  }
}
