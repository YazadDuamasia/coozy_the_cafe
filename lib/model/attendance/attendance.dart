class Attendance {
  int? id;
  int? employeeId;
  String? currentDate;
  String? checkIn;
  String? checkOut;
  String? employeeWorkingDurations;
  String? workingTimeDurations;

  Attendance({
    this.id,
    this.employeeId,
    this.currentDate,
    this.checkIn,
    this.checkOut,
    this.employeeWorkingDurations,
    this.workingTimeDurations,
  });

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json['id'],
        employeeId: json['employeeId'],
        currentDate: json['currentDate'] != null ? json['currentDate'] : null,
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
        'currentDate': currentDate,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'employeeWorkingDurations': employeeWorkingDurations,
        'workingTimeDurations': workingTimeDurations,
      }..removeWhere((key, value) => value == null);
}
