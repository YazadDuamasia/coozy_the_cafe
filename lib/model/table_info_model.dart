class TableInfoModel {
  int? id;
  String? name;
  String? colorValue;
  int? sortOrderIndex;
  int? nosOfChairs;

  TableInfoModel({
    this.id,
    this.name,
    this.sortOrderIndex,
    this.nosOfChairs,
    this.colorValue,
  });

  factory TableInfoModel.fromJson(Map<String, dynamic> json) {
    return TableInfoModel(
      id: json['id'],
      name: json['name'],
      sortOrderIndex: json['sortOrderIndex'],
      nosOfChairs: json['nosOfChairs'],
      colorValue: json['colorValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrderIndex': sortOrderIndex,
      'nosOfChairs': nosOfChairs,
      'colorValue': colorValue,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'TableInfoModel{id: $id, name: $name, sortOrderIndex: $sortOrderIndex, nosOfChairs: $nosOfChairs, colorValue: $colorValue}';
  }
}
