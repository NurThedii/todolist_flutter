class Label {
  final int id;
  final String title;

  Label({required this.id, required this.title});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id:
          json["id"] is int
              ? json["id"]
              : int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "Tidak ada nama label",
    );
  }
}
