class Tag {
  final String id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Static method to get the name of a tag by its ID
  static String getNameById(String id, List<Tag> tags) {
    final tag = tags.firstWhere(
      (tag) => tag.id == id,
      orElse: () => Tag(id: '', name: 'Unknown'),
    );
    return tag.name;
  }
}
