class Subcategory {
  int? id;
  String? name;
  String? createdDate;
  int? categoryId;

  Subcategory({this.id, this.name, this.createdDate, this.categoryId});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
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
    };
  }

  Subcategory copyWith({
    int? id,
    String? name,
    String? createdDate,
    int? categoryId,
  }) {
    return Subcategory(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  static List<String?>? getSubcategoryNames(List<Subcategory?>? subcategories) {
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
    return 'Subcategory(id: $id, name: $name,  createdDate: $createdDate, categoryId: $categoryId)';
  }
}
