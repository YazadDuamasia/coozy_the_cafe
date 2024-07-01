class Attendance {
  int? id;
  int? employeeId;
  String? checkIn;
  String? checkOut;
  String? employeeWorkingDurations;
  String? workingTimeDurations;
  String? creationDate;
  String? modificationDate;

  Attendance({
    this.id,
    this.employeeId,
    this.creationDate,
    this.modificationDate,
    this.checkIn,
    this.checkOut,
    this.employeeWorkingDurations,
    this.workingTimeDurations,
  });

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json['id'],
        employeeId: json['employeeId'],
        creationDate:
            json['creationDate'] != null ? json['creationDate'] : null,
        modificationDate:
            json['modificationDate'] != null ? json['modificationDate'] : null,
        checkIn: json['checkIn'] != null ? json['checkIn'] : null,
        checkOut: json['checkOut'] != null ? json['checkOut'] : null,
        employeeWorkingDurations: json['employeeWorkingDurations'] != null
            ? json['employeeWorkingDurations']
            : null,
        workingTimeDurations: json['workingTimeDurations'] != null
            ? json['workingTimeDurations']
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'creationDate': creationDate,
        'modificationDate': modificationDate,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'employeeWorkingDurations': employeeWorkingDurations,
        'workingTimeDurations': workingTimeDurations,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'Attendance{id: $id, employeeId: $employeeId, checkIn: $checkIn, checkOut: $checkOut, employeeWorkingDurations: $employeeWorkingDurations, workingTimeDurations: $workingTimeDurations, creationDate: $creationDate, modificationDate: $modificationDate}';
  }
}
