class CreationResponse {
  final int code;
  final bool success;
  final int timestamp;
  final String message;
  final Data data;

  CreationResponse({
    required this.code,
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory CreationResponse.fromJson(Map<String, dynamic> json) {
    return CreationResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      timestamp: json['timestamp'] as int,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}