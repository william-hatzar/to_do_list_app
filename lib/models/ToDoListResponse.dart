class TodoItem {
  final String id;
  final String title;
  final String description;
  late bool isCompleted = false;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }


}

class PaginatedResponse {
  final int code;
  final bool success;
  final int timestamp;
  final String message;
  final List<TodoItem> items;
  final MetaData meta;

  PaginatedResponse({
    required this.code,
    required this.success,
    required this.timestamp,
    required this.message,
    required this.items,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = json['items'] ?? [];
    final List<TodoItem> items =
    itemsJson.map((itemJson) => TodoItem.fromJson(itemJson)).toList();

    return PaginatedResponse(
      code: json['code'],
      success: json['success'],
      timestamp: json['timestamp'],
      message: json['message'],
      items: items,
      meta: MetaData.fromJson(json['meta']),
    );
  }
}

class MetaData {
  final int totalItems;
  final int totalPages;
  final int perPageItem;
  final int currentPage;
  final int pageSize;
  final bool hasMorePage;

  MetaData({
    required this.totalItems,
    required this.totalPages,
    required this.perPageItem,
    required this.currentPage,
    required this.pageSize,
    required this.hasMorePage,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      perPageItem: json['per_page_item'],
      currentPage: json['current_page'],
      pageSize: json['page_size'],
      hasMorePage: json['has_more_page'],
    );
  }
}