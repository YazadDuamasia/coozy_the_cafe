class MenuItem {
  int? id;
  String? name;
  String? description;
  DateTime? creationDate;
  int? duration = 0;
  int? categoryId;
  int? subcategoryId;
  bool? isTodayAvailable;
  bool?isSimpleVariation; //If it true then add field like unitPrice,sellingPrice,stockQuantity,purchaseUnit else false go for MenuItemVariation list
  double? costPrice; // Added unit price property
  double? sellingPrice; // Added selling price property
  double? stockQuantity;
  String?
      quantity; // New property for purchase unit (e.g., "500 grams", "500 kilo", "500 per piece")
  String?
      purchaseUnit; // New property for purchase unit (e.g., "grams", "kilo", "per piece")
  List<MenuItemVariation>? variations;

  MenuItem(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
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
      creationDate: DateTime.parse(json['creationDate']),
      duration: json['duration'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      isTodayAvailable: json['isTodayAvailable'],
      isSimpleVariation: json['isSimpleVariation'],
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
      'creationDate': creationDate?.toIso8601String(),
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
    DateTime? creationDate,
    int? duration,
    int? categoryId,
    int? subcategoryId,
    bool? isTodayAvailable,
    bool? isSimpleVariation,
    double? unitPrice,
    double? sellingPrice,
    double? stockQuantity,
    String? quantity,
    String? purchaseUnit,
    List<MenuItemVariation>? variations,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      isTodayAvailable: isTodayAvailable ?? this.isTodayAvailable,
      isSimpleVariation: isSimpleVariation ?? this.isSimpleVariation,
      costPrice: unitPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      quantity: quantity ?? this.quantity,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      variations: variations ?? this.variations,
    );
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, variations: $variations, ...)';
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

  MenuItemVariation({
    this.id,
    this.menuItemId,
    this.quantity,
    this.purchaseUnit,
    this.costPrice,
    this.sellingPrice,
    this.stockQuantity,
    this.isTodayAvailable,
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
      isTodayAvailable: json['isTodayAvailable'],
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
    );
  }


  @override
  String toString() {
    return 'MenuItemVariation{id: $id, menuItemId: $menuItemId, isTodayAvailable: $isTodayAvailable, quantity: $quantity, purchaseUnit: $purchaseUnit, costPrice: $costPrice, sellingPrice: $sellingPrice, stockQuantity: $stockQuantity}';
  }
}

//
MenuItem newMenuItem = MenuItem(
  name: 'Wheat Bread',
  description: 'Description of the new menu item with variations',
  isTodayAvailable: true,
  isSimpleVariation: false,
  variations: [
    MenuItemVariation(
      quantity: 150,
      purchaseUnit: 'grams',
      costPrice: 3.99,
      sellingPrice: 7.99,
      stockQuantity: 50,
    ),
    MenuItemVariation(
      quantity: 250,
      purchaseUnit: 'grams',
      costPrice: 6.99,
      sellingPrice: 12.99,
      stockQuantity: 30,
    ),
    // Add more variations as needed
  ],
);

MenuItem newMenuItem1 = MenuItem(
  name: 'Strawberry pastry',
  description: 'Description of the new menu item with variations',
  isTodayAvailable: true,
  isSimpleVariation: true,
  purchaseUnit: "pieces",
  quantity: "1",
  sellingPrice: 100,
  costPrice: 80,
  stockQuantity: 10,
);
