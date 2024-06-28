class Employee {
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? position;
  String? joiningDate;
  String? leavingDate;
  String? startWorkingTime;
  String? endWorkingTime;
  int? workingHours;

  Employee({
    this.id,
    this.name,
    this.phoneNumber,
    this.position,
    this.joiningDate,
    this.leavingDate,
    this.startWorkingTime,
    this.endWorkingTime,
    this.workingHours,
  });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        position: json['position'],
        joiningDate: json['joiningDate'] != null ? json['joiningDate'] : null,
        leavingDate: json['leavingDate'] != null ? json['leavingDate'] : null,
        startWorkingTime:
            json['startWorkingTime'] != null ? json['startWorkingTime'] : null,
        endWorkingTime:
            json['endWorkingTime'] != null ? json['endWorkingTime'] : null,
        workingHours:
            json['workingHours'] != null ? json['workingHours'] : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'position': position,
        'joiningDate': joiningDate,
        'leavingDate': leavingDate,
        'startWorkingTime': startWorkingTime,
        'endWorkingTime': endWorkingTime,
        'workingHours': workingHours,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'Employee{id: $id, name: $name, phoneNumber: $phoneNumber, position: $position, joiningDate: $joiningDate, leavingDate: $leavingDate, startWorkingTime: $startWorkingTime, endWorkingTime: $endWorkingTime, workingHours: $workingHours}';
  }
}
