class Label {
  final int id;
  final String title;

  Label({required this.id, required this.title});

  factory Label.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Label(id: 0, title: "Tanpa Label");
    }
    return Label(
      id: json["id"] as int,
      title: json["title"] ?? "Tanpa Label", 
    );
  }
}
