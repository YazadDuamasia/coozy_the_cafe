class MenuItem {
  int? id;
  String? name;
  String? description;
  String? creationDate;
  String? modificationDate;
  int? duration = 0;
  int? categoryId;
  int? subcategoryId;
  bool? isTodayAvailable;
  bool? isSimpleVariation; //If it true then add field like unitPrice,sellingPrice,stockQuantity,purchaseUnit else false go for MenuItemVariation list
  double? costPrice; // Added unit price property
  double? sellingPrice; // Added selling price property
  double? stockQuantity;
  String? purchaseUnit; // New property for purchase unit (e.g., "grams", "kilo", "per piece")
  String?quantity; // New property for purchase unit (e.g., "500 grams", "500 kilo", "500 per piece")
  List<MenuItemVariation>? variations;

  MenuItem(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.modificationDate,
      this.duration,
      this.categoryId,
      this.subcategoryId,
      this.isTodayAvailable,
      this.isSimpleVariation,
      this.costPrice,
      this.sellingPrice,
      this.stockQuantity,
      this.quantity,
      this.purchaseUnit,
      this.variations});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    List<dynamic> variationsJson = json['variations'] ?? [];
    List<MenuItemVariation> variations = variationsJson
        .map((variationJson) => MenuItemVariation.fromJson(variationJson))
        .toList();

    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creationDate: json['creationDate'] != null ? json['creationDate'] : null,
      modificationDate:
          json['modificationDate'] != null ? json['modificationDate'] : null,
      duration: json['duration'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      isTodayAvailable: json["isTodayAvailable"] == null
          ? false
          : json["isTodayAvailable"] == 1,
      isSimpleVariation: json["isSimpleVariation"] == null
          ? false
          : json["isSimpleVariation"] == 1,
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
      stockQuantity: json['stockQuantity'],
      purchaseUnit: json['purchaseUnit'],
      variations: variations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creationDate': creationDate,
      'modificationDate': modificationDate,
      'duration': duration,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'isTodayAvailable': isTodayAvailable,
      'isSimpleVariation': isSimpleVariation,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'stockQuantity': stockQuantity,
      'purchaseUnit': purchaseUnit,
      'variations': variations?.map((v) => v.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  MenuItem copyWith({
    int? id,
    String? name,
    String? description,
    String? creationDate,
    String? modificationDate,
    int? duration,
    int? categoryId,
    int? subcategoryId,
    bool? isTodayAvailable,
    bool? isSimpleVariation,
    double? costPrice,
    double? sellingPrice,
    double? stockQuantity,
    String? purchaseUnit,
    String? quantity,
    List<MenuItemVariation>? variations,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      modificationDate: modificationDate ?? this.modificationDate,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      isTodayAvailable: isTodayAvailable ?? this.isTodayAvailable,
      isSimpleVariation: isSimpleVariation ?? this.isSimpleVariation,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      quantity: quantity ?? this.quantity,
      variations: variations ?? this.variations,
    );
  }


  @override
  String toString() {
    return 'MenuItem{id: $id, name: $name, description: $description, creationDate: $creationDate, modificationDate: $modificationDate, duration: $duration, categoryId: $categoryId, subcategoryId: $subcategoryId, isTodayAvailable: $isTodayAvailable, isSimpleVariation: $isSimpleVariation, costPrice: $costPrice, sellingPrice: $sellingPrice, stockQuantity: $stockQuantity, purchaseUnit: $purchaseUnit, quantity: $quantity, variations: $variations}';
  }
}

class MenuItemVariation {
  int? id;
  int? menuItemId;
  bool? isTodayAvailable;
  int? quantity;
  String? purchaseUnit;
  double? costPrice;
  double? sellingPrice;
  int? stockQuantity;
  int? sortOrderIndex;
  String? creationDate;
  String? modificationDate;

  MenuItemVariation({
    this.id,
    this.menuItemId,
    this.quantity,
    this.purchaseUnit,
    this.costPrice,
    this.sellingPrice,
    this.stockQuantity,
    this.isTodayAvailable,
    this.sortOrderIndex,
    this.creationDate,
    this.modificationDate,
  });

  factory MenuItemVariation.fromJson(Map<String, dynamic> json) {
    return MenuItemVariation(
      id: json['id'],
      menuItemId: json['menuItemId'],
      quantity: json['quantity'],
      purchaseUnit: json['purchaseUnit'],
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
      stockQuantity: json['stockQuantity'],
      isTodayAvailable: json["isTodayAvailable"] == null
          ? false
          : json["isTodayAvailable"] == 1,
      sortOrderIndex: json['sortOrderIndex'],
      creationDate: json['creationDate'] != null ? json['creationDate'] : null,
      modificationDate:
          json['modificationDate'] != null ? json['modificationDate'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'quantity': quantity,
      'purchaseUnit': purchaseUnit,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'stockQuantity': stockQuantity,
      'isTodayAvailable': isTodayAvailable,
      'sortOrderIndex': sortOrderIndex,
      'creationDate': creationDate,
      'modificationDate': modificationDate,
    }..removeWhere((key, value) => value == null);
  }

  MenuItemVariation copyWith({
    int? id,
    int? menuItemId,
    bool? isTodayAvailable,
    int? quantity,
    String? purchaseUnit,
    double? costPrice,
    double? sellingPrice,
    int? stockQuantity,
    int? sortOrderIndex,
    String? creationDate,
    String? modificationDate,
  }) {
    return MenuItemVariation(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      isTodayAvailable: isTodayAvailable ?? this.isTodayAvailable,
      quantity: quantity ?? this.quantity,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sortOrderIndex: sortOrderIndex ?? this.sortOrderIndex,
      creationDate: creationDate ?? this.creationDate,
      modificationDate: modificationDate ?? this.modificationDate,
    );
  }

  @override
  String toString() {
    return 'MenuItemVariation{id: $id, menuItemId: $menuItemId, isTodayAvailable: $isTodayAvailable, quantity: $quantity, purchaseUnit: $purchaseUnit, costPrice: $costPrice, sellingPrice: $sellingPrice, stockQuantity: $stockQuantity, sortOrderIndex: $sortOrderIndex, creationDate: $creationDate, modificationDate: $modificationDate}';
  }
}
