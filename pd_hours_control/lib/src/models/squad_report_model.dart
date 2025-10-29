class SquadReportModel {
  final int employeeId;
  final String employeeName;
  final String? description;
  final double totalSpentHours;
  final DateTime createdAt;

  SquadReportModel({
    required this.employeeId,
    required this.employeeName,
    this.description,
    required this.totalSpentHours,
    required this.createdAt,
  });

  factory SquadReportModel.fromJson(Map<String, dynamic> json) {
    return SquadReportModel(
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      description: json['description'],
      totalSpentHours:
          double.tryParse(json['totalSpentHours'].toString()) ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
