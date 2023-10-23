class DeleteResponse {
  final int code;
  final bool success;
  final int timestamp;
  final String message;
  final TodoListItem data;

  DeleteResponse({
    required this.code,
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      timestamp: json['timestamp'] ?? 0,
      message: json['message'] ?? '',
      data: TodoListItem.fromJson(json['data'] ?? {}),
    );
  }
}

class TodoListItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoListItem.fromJson(Map<String, dynamic> json) {
    return TodoListItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}