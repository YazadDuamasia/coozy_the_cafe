import 'package:coozy_cafe/model/customer.dart';
import 'package:coozy_cafe/model/order_item.dart';

enum OrderStatus {
  newOrder, // 0
  inProgress, // 1
  completed, // 2
  canceled, // 3
  deleted, // 4
}

class OrderModel {
  int? id;
  int? tableInfoId;
  DateTime? creationDate;
  DateTime? modificationDate;
  bool? isCanceled = false;
  bool? isDeleted = false;

  // String? status;// Status "New Order" ,"Inprogress" , "Completed"
  OrderStatus? status;

  //  -- Store the name of the payment method
  String? paymentMethodName;

  // -- Storing JSON representation of payment method details
  String? paymentMethodDetails;
  String? deliveryAddress;
  Customer? customer;
  List<OrderItem?> orderItems;

  OrderModel({
    this.id,
    this.tableInfoId,
    this.creationDate,
    this.modificationDate,
    this.isCanceled,
    this.isDeleted,
    this.status,
    this.paymentMethodName,
    this.paymentMethodDetails,
    this.deliveryAddress,
    this.customer,
    this.orderItems = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Deserialize the customer
    final customerData = json['customer'] == null ? null : json['customer'];
    final Customer? customer =
        customerData == null ? null : Customer.fromJson(customerData);

    // Deserialize the order items
    final List<dynamic> items = json['orderItems'];
    final List<OrderItem> orderItems =
        items.map((item) => OrderItem.fromJson(item)).toList();
    // final statusIndex = json['status'] == null ? 0 : json['status'] as int?;
    // final status = statusIndex != null ? OrderStatus.values[statusIndex] : null;
    return OrderModel(
      id: json['id'],
      tableInfoId: json['tableInfoId'],
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate']),
      modificationDate: json['modificationDate'] == null
          ? null
          : DateTime.parse(json['modificationDate']),
      isCanceled: json['isCanceled'],
      isDeleted: json['isDeleted'],
      status: json['status'],
      // status: status,
      paymentMethodName: json['paymentMethodName'],
      paymentMethodDetails: json['paymentMethodDetails'],
      deliveryAddress: json['deliveryAddress'] ?? "",
      customer: customer,
      orderItems: orderItems,
    );
  }

  Map<String, dynamic> toJson() {
    // Serialize the customer
    final Map<String, dynamic> customerData = customer?.toJson() ?? {};

    // Serialize the order items
    final List<Map<String, dynamic>> itemData =
        orderItems.map((item) => item!.toJson()).toList();
    final statusIndex = status?.index;
    return {
      'id': id,
      'tableInfoId': tableInfoId,
      'creationDate':
          creationDate == null ? null : creationDate?.toIso8601String(),
      'modificationDate':
          modificationDate == null ? null : modificationDate?.toIso8601String(),
      'isCanceled': isCanceled,
      'isDeleted': isDeleted,
      'status': status,
      'paymentMethodName': paymentMethodName ?? "",
      'paymentMethodDetails': paymentMethodDetails ?? "",
      'deliveryAddress': deliveryAddress ?? "",
      'customer': customerData,
      'orderItems': itemData,
    }..removeWhere((key, value) => value == null);
  }
}

/*
  OrderModel newOrder = OrderModel(
    // Other order properties...
    orderItems: [
      OrderItem(
        id: 12,
        itemId: 1,
        quantity: 3,
        status: 'New',
        isMenuItem: true,
        menuItem: newMenuItem,
        selectedVariation: null, // Set to null as it's a menu item
      ),
      OrderItem(
        id: 13,
        itemId: newMenuItem1.variations![0].id, // Variation 1 ID
        quantity: 2,
        status: 'New',
        isMenuItem: false,
        menuItem: newMenuItem,
        selectedVariation: newMenuItem.variations![0],
      ),
      OrderItem(
        id: 14,
        itemId: newMenuItem2.variations![1].id, // Variation 2 ID
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
