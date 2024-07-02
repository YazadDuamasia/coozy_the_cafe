class Leave {
  int? id;
  int? employeeId;
  int? currentStatus;
  int? isDeleted; // 0 is false and 1 is for true
  String? startDate;
  String? endDate;
  String? reason;
  String? creationDate;
  String? modificationDate;

  Leave(
      {this.id,
      required this.employeeId,
      required this.currentStatus,
      this.isDeleted,
      this.startDate,
      this.endDate,
      this.reason,
      this.creationDate,
      this.modificationDate});

  factory Leave.fromMap(Map<String, dynamic> json) => Leave(
      id: json['id'],
      employeeId: json['employeeId'],
      currentStatus: json['currentStatus'],
      isDeleted: json['isDeleted'] != null ? json['isDeleted'] : 0,
      startDate: json['startDate'] != null ? json['startDate'] : null,
      endDate: json['endDate'] != null ? json['endDate'] : null,
      creationDate: json['creationDate'] != null ? json['creationDate'] : null,
      modificationDate:
          json['modificationDate'] != null ? json['modificationDate'] : null,
      reason: json['reason'] != null ? json['reason'] : null);

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'currentStatus': currentStatus,
        'isDeleted': isDeleted ?? 0,
        'creationDate': creationDate,
        'modificationDate': modificationDate,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'Leave{id: $id, employeeId: $employeeId, currentStatus: $currentStatus, isDeleted: $isDeleted, startDate: $startDate, endDate: $endDate, reason: $reason, creationDate: $creationDate, modificationDate: $modificationDate}';
  }
}
