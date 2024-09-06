class InventoryModel {
  int? id;
  String? hashId;
  String? name;
  String? shortDescription;
  String? purchaseUnit;
  double? currentStock;
  String? createdDate; // using String instead of DateTime
  String? modifiedDate; // using String instead of DateTime

  InventoryModel({
    this.id,
    this.hashId,
    this.name,
    this.shortDescription,
    this.purchaseUnit,
    this.currentStock,
    this.createdDate,
    this.modifiedDate,
  });

  // Convert a JSON object into an InventoryItem instance
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: (json['id'] == null) ? null : json['id'],
      hashId: (json['hashId'] == null) ? null : json['hashId'],
      name: (json['name'] == null) ? null : json['name'],
      shortDescription:
          (json['shortDescription'] == null) ? null : json['shortDescription'],
      purchaseUnit:
          (json['purchaseUnit'] == null) ? null : json['purchaseUnit'],
      currentStock: (json['currentStock'] == null)
          ? null
          : json['currentStock'].toDouble(),
      createdDate: (json['createdDate'] == null) ? null : json['createdDate'],
      modifiedDate:
          (json['modifiedDate'] == null) ? null : json['modifiedDate'],
    );
  }

  // Convert an InventoryItem instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hashId': hashId,
      'name': name,
      'shortDescription': shortDescription,
      'purchaseUnit': purchaseUnit,
      'currentStock': currentStock,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
    }..removeWhere((key, value) => value == null);
  }

  InventoryModel copyWith({
    int? id,
    String? hashId,
    String? name,
    String? shortDescription,
    String? purchaseUnit,
    double? currentStock,
    String? createdDate,
    String? modifiedDate,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      hashId: hashId ?? this.hashId,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      currentStock: currentStock ?? this.currentStock,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  @override
  String toString() {
    return 'InventoryModel{id: $id, hashId: $hashId, name: $name, shortDescription: $shortDescription, purchaseUnit: $purchaseUnit, currentStock: $currentStock, createdDate: $createdDate, modifiedDate: $modifiedDate}';
  }
}
