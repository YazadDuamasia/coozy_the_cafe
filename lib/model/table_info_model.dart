class TableInfoModel {
  int? id;
  String? name;
  int? sortOrderIndex;
  int? nosOfChairs;

  TableInfoModel({
    this.id,
    this.name,
    this.sortOrderIndex,
    this.nosOfChairs,
  });

  factory TableInfoModel.fromJson(Map<String, dynamic> json) {
    return TableInfoModel(
      id: json['id'],
      name: json['name'],
      sortOrderIndex: json['sortOrderIndex'],
      nosOfChairs: json['nosOfChairs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrderIndex': sortOrderIndex,
      'nosOfChairs': nosOfChairs,
    };
  }

  @override
  String toString() {
    return 'TableInfoModel{id: $id, name: $name, sortOrderIndex: $sortOrderIndex, nosOfChairs: $nosOfChairs}';
  }
}
