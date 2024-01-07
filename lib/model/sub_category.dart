class SubCategory {
  int? id;
  String? name;
  String? createdDate;
  int? categoryId;

  SubCategory({this.id, this.name, this.createdDate, this.categoryId});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      createdDate: json['createdDate'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'categoryId': categoryId
    }..removeWhere((key, value) => value == null);
  }

  SubCategory copyWith({
    int? id,
    String? name,
    String? createdDate,
    int? categoryId,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  static List<String?>? getSubCategoryNames(List<SubCategory?>? subcategories) {
    if (subcategories == null) {
      return null;
    } else {
      return subcategories
          .map((subcategory) => subcategory?.name ?? "")
          .toList();
    }
  }

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name,  createdDate: $createdDate, categoryId: $categoryId)';
  }
}
