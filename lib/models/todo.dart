class Todo {
  final int id;
  final String title;
  final String? description;
  final int categoryId;
  final int labelId;
  final String status;
  final String deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.categoryId,
    required this.labelId,
    required this.status,
    required this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"] as int,
      title: json["title"] ?? "Tidak ada judul",
      description: json["description"],
      categoryId:
          json["category_id"] is int
              ? json["category_id"]
              : int.tryParse(json["category_id"].toString()) ?? 0,
      labelId:
          json["label_id"] is int
              ? json["label_id"]
              : int.tryParse(json["label_id"].toString()) ?? 0,
      status: json["status"] ?? "Tidak diketahui",
      deadline: json["deadline"] ?? "Tidak ada deadline",
      createdAt:
          json["created_at"] != null
              ? DateTime.tryParse(json["created_at"])
              : null,
      updatedAt:
          json["updated_at"] != null
              ? DateTime.tryParse(json["updated_at"])
              : null,
    );
  }
}
