class ExpenseCategory {
  final String id;
  final String name;
  final bool isDefault;
  final List<SubCategory> subCategories;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.isDefault = false,
    this.subCategories = const [],
  });

  // Factory constructor for creating a new ExpenseCategory instance from a JSON map
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((e) => SubCategory.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Method for converting an ExpenseCategory instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subCategories': subCategories.map((e) => e.toJson()).toList(),
    };
  }

  // Static method to get the name of a category by its ID
  static String getNameById(String id, List<ExpenseCategory> categories) {
    final category = categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => ExpenseCategory(id: '', name: 'Unknown'),
    );
    return category.name;
  }
}

class SubCategory {
  final String id;
  final String name;

  SubCategory({
    required this.id,
    required this.name,
  });

  // Factory constructor for creating a new SubCategory instance from a JSON map
  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  // Method for converting a SubCategory instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
