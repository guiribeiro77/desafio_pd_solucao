class SquadModel {
  final int id;
  final String name;

  SquadModel({required this.id, required this.name});

  factory SquadModel.fromJson(Map<String, dynamic> json) {
    return SquadModel(id: json['id'], name: json['name']);
  }
}
