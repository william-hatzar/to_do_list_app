class TaskRequest {

  final String title;
  final String description;
  final bool isCompleted;

  TaskRequest({
    required this.title,
    required this.description,
    required this.isCompleted
});


  // Factory constructor to create a TodoItem from a JSON map
  factory TaskRequest.fromJson(Map<String, dynamic> json) {
    return TaskRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool,
    );
  }
  // Convert a TodoItem object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}
