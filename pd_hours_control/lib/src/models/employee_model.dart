class EmployeeModel {
  final int id;
  final String name;
  final double estimatedHours;
  final int squadId;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.estimatedHours,
    required this.squadId,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      estimatedHours: (json['estimatedHours'] as num).toDouble(),
      squadId: json['squadId'],
    );
  }
}
