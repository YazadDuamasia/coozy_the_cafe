class PurchaseModel {
  int? id;
  String? hashId;
  int? inventoryId;
  String? name;
  String? purchaseUnit;
  double? purchaseQty;
  String? purchaseDateTime;
  double? purchasePrice;
  String? createdDate;
  String? modifiedDate;

  PurchaseModel({
    this.id,
    this.hashId,
    this.inventoryId,
    this.name,
    this.purchaseUnit,
    this.purchaseQty,
    this.purchaseDateTime,
    this.purchasePrice,
    this.createdDate,
    this.modifiedDate,
  });

  // Convert a JSON object into a PurchaseItem instance
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: (json['id'] == null) ? null : json['id'],
      hashId: (json['hashId'] == null) ? null : json['hashId'],
      inventoryId: (json['inventoryId'] == null) ? null : json['inventoryId'],
      name: (json['name'] == null) ? null : json['name'],
      purchaseUnit:
          (json['purchaseUnit'] == null) ? null : json['purchaseUnit'],
      purchaseQty:
          (json['purchaseQty'] == null) ? null : json['purchaseQty'].toDouble(),
      purchaseDateTime: json['purchaseDateTime'] as String?,
      purchasePrice: (json['currentStock'] == null)
          ? null
          : (json['purchasePrice'] != null)
              ? json['purchasePrice'].toDouble()
              : null,
      createdDate: (json['createdDate'] == null) ? null : json['createdDate'],
      // handling null value
      modifiedDate:
          (json['modifiedDate'] == null) ? null : json['modifiedDate'],
    );
  }

  // Convert a PurchaseItem instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hashId': hashId,
      'inventoryId': inventoryId,
      'name': name,
      'purchaseUnit': purchaseUnit,
      'purchaseQty': purchaseQty,
      'purchaseDateTime': purchaseDateTime,
      'purchasePrice': purchasePrice,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
    }..removeWhere((key, value) => value == null);
  }

  PurchaseModel copyWith({
    int? id,
    String? hashId,
    int? inventoryId,
    String? name,
    String? purchaseUnit,
    double? purchaseQty,
    String? purchaseDateTime,
    double? purchasePrice,
    String? createdDate,
    String? modifiedDate,
  }) {
    return PurchaseModel(
      id: id ?? this.id,
      hashId: hashId ?? this.hashId,
      inventoryId: inventoryId ?? this.inventoryId,
      name: name ?? this.name,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      purchaseQty: purchaseQty ?? this.purchaseQty,
      purchaseDateTime: purchaseDateTime ?? this.purchaseDateTime,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  @override
  String toString() {
    return 'PurchaseModel{id: $id, hashId: $hashId, inventoryId: $inventoryId, name: $name, purchaseUnit: $purchaseUnit, purchaseQty: $purchaseQty, purchaseDateTime: $purchaseDateTime, purchasePrice: $purchasePrice, createdDate: $createdDate, modifiedDate: $modifiedDate}';
  }
}
