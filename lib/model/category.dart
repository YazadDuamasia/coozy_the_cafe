class Category {
  int? id;
  int? isActive;
  String? name;
  String? createdDate;

  Category({this.id, this.name, this.createdDate, this.isActive});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'isActive': isActive,
    }..removeWhere((key, value) => value == null);
  }

  Category copyWith({
    int? id,
    int? isActive,
    String? name,
    String? createdDate,
  }) {
    return Category(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, isActive: $isActive, name: $name, createdDate: $createdDate}';
  }

}
