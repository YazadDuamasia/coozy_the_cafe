class Leave {
  int? id;
  int? employeeId;
  String? startDate;
  String? endDate;
  String? reason;
  String? creationDate;
  String? modificationDate;

  Leave(
      {this.id,
      required this.employeeId,
      this.startDate,
      this.endDate,
      this.reason,
      this.creationDate,
      this.modificationDate});

  factory Leave.fromMap(Map<String, dynamic> json) => Leave(
      id: json['id'],
      employeeId: json['employeeId'],
      startDate: json['startDate'] != null ? json['startDate'] : null,
      endDate: json['endDate'] != null ? json['endDate'] : null,
      creationDate: json['creationDate'] != null ? json['creationDate'] : null,
      modificationDate:
          json['modificationDate'] != null ? json['modificationDate'] : null,
      reason: json['reason'] != null ? json['reason'] : null);

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'creationDate': creationDate,
        'modificationDate': modificationDate,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'Leave{id: $id, employeeId: $employeeId, startDate: $startDate, endDate: $endDate, reason: $reason, creationDate: $creationDate, modificationDate: $modificationDate}';
  }
}
