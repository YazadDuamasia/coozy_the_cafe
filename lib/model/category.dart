class Category {
  int? id;
  String? name;
  String? createdDate;

  Category({this.id, this.name, this.createdDate});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? createdDate,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, createdDate: $createdDate}';
  }
}
