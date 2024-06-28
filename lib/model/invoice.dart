import 'package:coozy_the_cafe/model/order_item.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';

class PaymentMode {
  int? id;
  String? paymentMethodName;
  String? uniqueHashId;

  PaymentMode({this.id, this.paymentMethodName, this.uniqueHashId});

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      id: json['id'] as int?,
      paymentMethodName: json['paymentMethodName'] as String?,
      uniqueHashId: json['uniqueHashId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentMethodName': paymentMethodName,
      'uniqueHashId': uniqueHashId,
    }..removeWhere((key, value) => value == null);
  }
}

class Invoice {
  int? id;
  int? orderId;
  String? invoiceHashId;
  String? paymentMethodDetails;
  double? taxPercentage;

  // discountType   -- 0 for percentage, 1 for flat
  bool? discountType;
  double? discountAmount;
  double? totalCost;
  double? taxableAmount;
  double? netPaymentAmount;
  String? createdDate;
  String? modifiedDate;
  int? customerId;
  String? customerName;
  String? phoneNumber;
  int? paymentModeId;
  String? paymentMethodName;
  double? recordAmountPaid;
  List<OrderItem>? orderItems; // List of OrderItem objects

  Invoice({
    this.id,
    this.orderId,
    this.invoiceHashId,
    this.paymentMethodDetails,
    this.taxPercentage,
    this.discountType,
    this.discountAmount,
    this.totalCost,
    this.taxableAmount,
    this.netPaymentAmount,
    this.createdDate,
    this.modifiedDate,
    this.customerId,
    this.customerName,
    this.phoneNumber,
    this.paymentModeId,
    this.paymentMethodName,
    this.recordAmountPaid,
    this.orderItems, // Initialize the list here
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      orderId: json['orderId'],
      invoiceHashId: json['invoiceHashId'],
      taxPercentage: json['taxPercentage'],
      discountType: (json['discountType'] == null || json['discountType'] == 1)
          ? true
          : false,
      discountAmount: json['discountAmount'],
      totalCost: json['totalCost'] as double?,
      taxableAmount: json['taxableAmount'],
      paymentMethodDetails: json['paymentMethodDetails'],
      netPaymentAmount: json['netPaymentAmount'],
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      paymentModeId: json['paymentModeId'],
      paymentMethodName: json['paymentMethodName'],
      recordAmountPaid: json['recordAmountPaid'],
      orderItems: json['orderItems'] == null
          ? null
          : json['orderItems'].map((item) => OrderItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'invoiceHashId': invoiceHashId,
      'paymentMethodDetails': paymentMethodDetails,
      'taxPercentage': taxPercentage,
      'discountType': (discountType == null || discountType == true) ? 1 : 0,
      'discountAmount': discountAmount,
      'totalCost': totalCost,
      'taxableAmount': taxableAmount,
      'netPaymentAmount': netPaymentAmount,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
      'customerId': customerId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'paymentModeId': paymentModeId,
      'paymentMethodName': paymentMethodName,
      'recordAmountPaid': recordAmountPaid,
      'orderItems': orderItems == null
          ? null
          : orderItems!.map((item) => item.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  String generateInvoiceHashId(var orderId) {
    DateTime now = DateTime.now();

    return "INV-${DateUtil.localFormatDateTime(now, "ddMMyyyyHH:mm")}-$orderId";
  }
// Invoice newInvoice = Invoice(
//   // other properties...
//   invoiceHashId: generateInvoiceHashId(),
// );
}
