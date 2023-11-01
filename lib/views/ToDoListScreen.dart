import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/ToDoListResponse.dart';
import 'package:to_do_list_app/models/DeleteResponse.dart';
import 'package:to_do_list_app/connectors/ToDoListConnector.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_app/models/TaskRequest.dart';
import 'package:to_do_list_app/widgets/Header.dart';
import 'package:to_do_list_app/widgets/TaskInput.dart';
import 'package:to_do_list_app/state/app_state.dart';
import 'package:provider/provider.dart';

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

  void toggleCheckbox(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  // Define a filter variable to track the current filter state
  FilterState _currentFilter = FilterState.all;

  // Define a function to update the filter state
  void updateFilter(FilterState filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

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
    final bool darkMode = Provider.of<AppState>(context).darkMode;
    String imagePath =
    darkMode ? "images/bg-mobile-dark.jpeg" : "images/bg-mobile-light.jpeg";
    return Scaffold(
      backgroundColor: darkMode ? const Color(0xFF171721) : Colors.grey[100],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 80),
              const HeaderSection(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder<PaginatedResponse>(
                    future: futureToDoList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 24, // Set the width to your desired size
                            height: 24, // Set the height to your desired size
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Text('Failed to connect', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Josefin Sans", color: darkMode ? Colors.white : Colors.black87, fontSize: 30)),
                          ],
                        );
                      } else {
                        final data = snapshot.data;
                        List<TodoItem> filteredTasks = [];
                        switch (_currentFilter) {
                          case FilterState.all:
                            filteredTasks = data!.items;
                            break;
                          case FilterState.active:
                            filteredTasks = data!.items
                                .where((task) => !task.isCompleted)
                                .toList();
                            break;
                          case FilterState.completed:
                            filteredTasks = data!.items
                                .where((task) => task.isCompleted)
                                .toList();
                            break;
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ReorderableListView.builder(
                                header: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    TaskInputSection(
                                        todoTextController: _todoTextController,
                                        isChecked: _isChecked,
                                        addTaskCallback: _addTask,
                                        toggleCheckboxCallback: toggleCheckbox),
                                    SizedBox(height: 20)
                                  ],
                                ),
                                footer: Column(
                                  children: [
                                    Container(
                                      key: UniqueKey(),
                                      height: 60.00,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                        color: darkMode
                                            ? const Color(0xFF25273D)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: darkMode
                                            ? Border.all(
                                                color: const Color(0xFF25273D))
                                            : Border.all(color: Colors.white),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            filteredTasks.length > 1
                                                ? "${filteredTasks.length} items left"
                                                : filteredTasks.length == 1
                                                    ? "1 item left"
                                                    : "You have no tasks left",
                                            style: TextStyle(
                                              color: darkMode
                                                  ? Colors.grey
                                                  : Colors.blueGrey,
                                              fontFamily: "Josefin Sans",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Filter out completed items
                                              final completedItems =
                                                  filteredTasks
                                                      .where((task) =>
                                                          task.isCompleted)
                                                      .toList();
                                              if (completedItems.isNotEmpty) {
                                                for (final item
                                                    in completedItems) {
                                                  deleteData(item.id)
                                                      .then((response) {
                                                    if (response.success) {
                                                      setState(() {
                                                        filteredTasks
                                                            .remove(item);
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Failed to delete completed items."),
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
                                                color: darkMode
                                                    ? Colors.grey
                                                    : Colors.blueGrey,
                                                fontFamily: "Josefin Sans",
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    FilterBox(
                                        currentFilter: _currentFilter,
                                        updateFilterCallback: updateFilter,
                                        darkMode: darkMode),
                                    const SizedBox(height: 40),
                                     Text("Drag and drop to reorder list", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Josefin Sans", color: darkMode ? Colors.white : Colors.black87))
                                  ],
                                ),
                                itemCount: filteredTasks.length,
                                onReorder: (oldIndex, newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final TodoItem item =
                                        filteredTasks.removeAt(oldIndex);
                                    filteredTasks.insert(newIndex, item);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  return Dismissible(
                                    key: Key(task.id.toString()),
                                    onDismissed: (direction) {
                                      final itemId = task.id;
                                      deleteData(itemId).then((response) {
                                        if (response.success) {
                                          setState(() {
                                            filteredTasks.remove(task);
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Failed to delete item."),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60.00,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: darkMode
                                                ? const Color(0xFF25273D)
                                                : Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: index == 0
                                                  ? const Radius.circular(10)
                                                  : Radius.zero,
                                              bottom: index ==
                                                      filteredTasks.length - 1
                                                  ? const Radius.circular(10)
                                                  : Radius.zero,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    task.isCompleted =
                                                        !task.isCompleted;
                                                  });
                                                },
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.blueGrey),
                                                  ),
                                                  child: Center(
                                                    child: task.isCompleted
                                                        ? const Icon(
                                                            Icons.check,
                                                            size: 16,
                                                            color:
                                                                Colors.blueGrey,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    color: darkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontFamily: "Josefin Sans",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  final itemId = task.id;
                                                  deleteData(itemId)
                                                      .then((response) {
                                                    if (response.success) {
                                                      setState(() {
                                                        filteredTasks
                                                            .remove(task);
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Failed to delete item."),
                                                        ),
                                                      );
                                                    }
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index < filteredTasks.length - 1)
                                          Divider(
                                            color: darkMode? Colors.black12 : Colors.grey[300],
                                            height: 0,
                                            thickness: 1,
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum FilterState { all, active, completed }

class FilterBox extends StatelessWidget {
  final FilterState currentFilter;
  final Function(FilterState) updateFilterCallback;
  final bool darkMode;

  FilterBox(
      {required this.currentFilter,
      required this.updateFilterCallback,
      required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkMode ? const Color(0xFF25273D) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FilterButton(
            label: "All",
            isActive: currentFilter == FilterState.all,
            onPressed: () => updateFilterCallback(FilterState.all),
          ),
          FilterButton(
            label: "Active",
            isActive: currentFilter == FilterState.active,
            onPressed: () => updateFilterCallback(FilterState.active),
          ),
          FilterButton(
            label: "Completed",
            isActive: currentFilter == FilterState.completed,
            onPressed: () => updateFilterCallback(FilterState.completed),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  FilterButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.grey,
          fontFamily: "Josefin Sans",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
