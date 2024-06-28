class Attendance {
  int? id;
  int? employeeId;
  String? currentDate;
  String? checkIn;
  String? checkOut;
  String? overTimeEnded;
  int? overTimeDurationsInSeconds;

  Attendance({
    this.id,
    this.employeeId,
    this.currentDate,
    this.checkIn,
    this.checkOut,
    this.overTimeEnded,
    this.overTimeDurationsInSeconds,
  });

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json['id'],
        employeeId: json['employeeId'],
        currentDate: json['currentDate'] != null ? json['currentDate'] : null,
        checkIn: json['checkIn'] != null ? json['checkIn'] : null,
        checkOut: json['checkOut'] != null ? json['checkOut'] : null,
        overTimeEnded:
            json['overTimeEnded'] != null ? json['overTimeEnded'] : null,
        overTimeDurationsInSeconds: json['overTimeDurationsInSeconds'] != null
            ? json['overTimeDurationsInSeconds']
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'currentDate': currentDate,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'overTimeEnded': overTimeEnded,
        'overTimeDurationsInSeconds': overTimeDurationsInSeconds,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'Attendance{id: $id, employeeId: $employeeId, currentDate: $currentDate, checkIn: $checkIn, checkOut: $checkOut, overTimeEnded: $overTimeEnded, overTimeDurationsInSeconds: $overTimeDurationsInSeconds}';
  }
}
