import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'connectors/ToDoListConnector.dart';
import 'models/ToDoListResponse.dart';
import 'models/DeleteResponse.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_app/models/TaskRequest.dart';

void main() => runApp(const Root());

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To Do List App",
      home: ToDoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  late Future<PaginatedResponse> futureToDoList;
  late Future<DeleteResponse> futureDeleteResponse;
  final TextEditingController _todoTextController = TextEditingController();
  bool _isChecked = false;
  List<TodoItem> _todoList = [];

  // Function to add a task
  void _addTask() async {
    final newTask = TaskRequest(
      title: _todoTextController.text,
      description: 'Description goes here', // Modify this as needed
      isCompleted: _isChecked, // Modify this as needed
    );

    try {
      final response = await createTask(newTask);

      if (response.success) {
        _todoTextController.clear();
        setState(() {
          _isChecked = false;
        });
        futureToDoList = fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create a task."),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create a task: $error"),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    futureToDoList = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset("images/bg-mobile-light.jpeg", fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(20.00),
              child: const Text(
                "T O D O",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Josefin Sans",
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 320,
            child: Container(
              padding: const EdgeInsets.all(20.00),
              child: SvgPicture.asset("images/icon-moon.svg"),
            ),
          ),
          Positioned(
            top: 125,
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                // ... (existing code)

                // Add a text field with a checkbox and text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RawKeyboardListener(
                    focusNode: FocusNode(), // Create a FocusNode to receive keyboard events
                    onKey: (RawKeyEvent event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter) {
                        // "Enter" key is pressed, add the task
                        _addTask();
                      }
                    },
                    child: Row(
                      children: [
                        // Checkbox
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        // Text
                        Expanded(
                          child: TextField(
                            controller: _todoTextController,
                            decoration: InputDecoration(
                              hintText: 'Add a new task...',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Josefin Sans",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )],
            ),
          ),
          Positioned(
            top: 135,
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<PaginatedResponse>(
                    future: futureToDoList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: SizedBox(
                          width: 24, // Set the width to your desired size
                          height: 24, // Set the height to your desired size
                          child: CircularProgressIndicator(),
                        )); // Display a loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Display your data here
                        final data = snapshot.data;
                        // Return your UI based on the data
                        return ListView.builder(
                          itemCount: (data!).items.length + 1,
                          itemBuilder: (context, index) {
                            if (index == data.items.length) {
                              // Return the "Clear Completed" button
                              return Container(
                                height: 60.00,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Items: ${data.items.length}",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontFamily: "Josefin Sans",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Filter out completed items
                                        final completedItems = data.items.where((task) => task.isCompleted).toList();
                                        if (completedItems.isNotEmpty) {
                                          for (final item in completedItems) {
                                            deleteData(item.id).then((response) {
                                              if (response.success) {
                                                setState(() {
                                                  data.items.remove(item);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Failed to delete completed items."),
                                                  ),
                                                );
                                              }
                                            });
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Clear Completed",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Josefin Sans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            // Return a list item
                            return Dismissible(
                              key: Key(data.items[index].id.toString()),
                              onDismissed: (direction) {
                                final itemId = data.items[index].id;
                                deleteData(itemId).then((response) {
                                  if (response.success) {
                                    setState(() {
                                      data.items.removeAt(index);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Failed to delete item."),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 60.00,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: index == 0 ? const Radius.circular(10) : Radius.zero,
                                        bottom: index == data.items.length - 1 ? const Radius.circular(10) : Radius.zero,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              data.items[index].isCompleted = !data.items[index].isCompleted;
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.blueGrey),
                                            ),
                                            child: Center(
                                              child: data.items[index].isCompleted
                                                  ? Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.blueGrey,
                                              )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            data.items[index].title,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Josefin Sans",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final itemId = data.items[index].id;
                                            deleteData(itemId).then((response) {
                                              if (response.success) {
                                                setState(() {
                                                  data.items.removeAt(index);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Failed to delete item."),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < data.items.length - 1)
                                    Divider(
                                      color: Colors.grey[300],
                                      height: 0,
                                      thickness: 1,
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey[100],
                  height: 0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}