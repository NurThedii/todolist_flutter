class Category {
  final int id;
  final String title;

  Category({required this.id, required this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id:
          json["id"] is int
              ? json["id"]
              : int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "Tidak ada nama kategori",
    );
  }

}
