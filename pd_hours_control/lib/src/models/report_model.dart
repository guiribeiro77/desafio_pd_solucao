class ReportModel {
  final int id;
  final String description;
  final int employeeId;
  final int spentHours;

  ReportModel({
    required this.id,
    required this.description,
    required this.employeeId,
    required this.spentHours,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      description: json['description'],
      employeeId: json['employeeId'],
      spentHours: json['spentHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'employeeId': employeeId,
      'spentHours': spentHours,
    };
  }
}
