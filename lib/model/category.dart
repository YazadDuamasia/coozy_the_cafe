class Category {
  int? id;
  int? isActive;
  int? position;
  String? name;
  String? createdDate;

  Category(
      {this.id, this.name, this.createdDate, this.isActive, this.position});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'],
      createdDate: json['createdDate'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'isActive': isActive,
      'position': position,
    }..removeWhere((key, value) => value == null);
  }

  Category copyWith({
    int? id,
    int? isActive,
    String? name,
    String? createdDate,
    int? position,
  }) {
    return Category(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, isActive: $isActive, position: $position, name: $name, createdDate: $createdDate}';
  }
}
