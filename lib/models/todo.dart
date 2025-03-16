class Todo {
  final int id;
  final String title;
  final String? description; // Nullable
  final int categoryId;
  final int labelId;
  final String status;
  final String deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description, // Nullable
    required this.categoryId,
    required this.labelId,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      title: json["title"],
      description:
          json["description"] ?? "", // Jika null, jadikan string kosong
      categoryId: json["category_id"],
      labelId: json["label_id"],
      status: json["status"],
      deadline: json["deadline"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
