class Customer {
  int? id;
  String? name;
  String? phoneNumber;

  Customer({this.id, this.name, this.phoneNumber});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    }..removeWhere((key, value) => value == null);
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phoneNumber,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, phoneNumber: $phoneNumber)';
  }
}
