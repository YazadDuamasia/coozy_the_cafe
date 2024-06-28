class Leave {
  int? id;
  int employeeId;
  DateTime? startDate;
  DateTime? endDate;
  String? reason;

  Leave({
    this.id,
    required this.employeeId,
    this.startDate,
    this.endDate,
    this.reason,
  });

  factory Leave.fromMap(Map<String, dynamic> json) => Leave(
    id: json['id'],
    employeeId: json['employeeId'],
    startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    reason: json['reason'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'employeeId': employeeId,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'reason': reason,
  }..removeWhere((key, value) => value == null);
}