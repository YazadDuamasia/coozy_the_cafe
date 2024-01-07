import 'package:coozy_cafe/model/menu_item.dart';

enum OrderItemStatus {
  newOrder, // 0
  inPreparation, // 1
  delivered, // 2
  canceled, // 3
  deleted, // 4
}

class OrderItem {
  int? id; // Unique ID for the order item
  int? orderId; // ID of the associated order
  int? itemId; // ID of the menu item
  int? quantity; // Quantity of the menu item in the order
  String? status; //Status "New" ,"In Preparation", "Delivered"
  // OrderItemStatus? status; //Status "New" ,"In Preparation", "Delivered"

  double? costPrice=0;
  double? sellingPrice=0;
  bool? isMenuItem; // Flag to determine if the order item is a menu item or a variation
  MenuItem? menuItem; // Reference to the menu item
  MenuItemVariation? selectedVariation;

  OrderItem(
      {this.id,
      this.orderId,
      this.itemId,
      this.quantity,
      this.costPrice,
      this.sellingPrice,
      this.status,
      this.isMenuItem,
      this.menuItem,
      this.selectedVariation}); // Reference to the selected variation



  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final statusIndex = json['status']==null?0:json['status'] as int?;
    final status = statusIndex != null ? OrderItemStatus.values[statusIndex] : null;

    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      itemId: json['itemId'],
      quantity: json['quantity'],
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
      status: json['status'],
      // status: status,

      isMenuItem: json['isMenuItem'],
      menuItem: json['menuItem'] != null ? MenuItem.fromJson(json['menuItem']) : null,
      selectedVariation: json['selectedVariation'] != null ? MenuItemVariation.fromJson(json['selectedVariation']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'itemId': itemId,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'costPrice': costPrice,
      'status': status,
      // 'status': status?.index,
      'isMenuItem': isMenuItem,
      'menuItem': menuItem?.toJson(),
      'selectedVariation': selectedVariation?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}
/*
OrderModel newOrder = OrderModel(
  // Other order properties...
  orderItems: [
    OrderItem(
      itemId: newMenuItem.id,
      quantity: 3,
      status: 'New',
      isMenuItem: true,
      menuItem: newMenuItem,
      selectedVariation: null, // Set to null as it's a menu item
    ),
    OrderItem(
      itemId: newMenuItem.variations![0].id, // Variation 1 ID
      quantity: 2,
      status: 'New',
      isMenuItem: false,
      menuItem: newMenuItem,
      selectedVariation: newMenuItem.variations![0],
    ),
    OrderItem(
      itemId: newMenuItem.variations![1].id, // Variation 2 ID
      quantity: 1,
      status: 'New',
      isMenuItem: false,
      menuItem: newMenuItem,
      selectedVariation: newMenuItem.variations![1],
    ),
    // Add more order items as needed
  ],
);
*/
