import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pd_hours_control/src/configs/api_config.dart';
import 'package:pd_hours_control/src/models/squad_report_model.dart';

class SquadReportController extends GetxController {
  final isLoading = false.obs;
  final reports = <SquadReportModel>[].obs;
  final totalHours = 0.0.obs;
  final averagePerDay = 0.0.obs;
  final startDate = DateTime.now().subtract(const Duration(days: 7)).obs;
  final endDate = DateTime.now().obs;
  final squadId = 0.obs;
  final squadName = ''.obs;

  // Busca os dados do relatório da squad
  Future<void> fetchSquadReports() async {
    if (squadId.value == 0) return;

    isLoading.value = true;

    final start = startDate.value.toIso8601String().split('T').first;
    final end = endDate.value.toIso8601String().split('T').first;

    try {
      final urlMembers = Uri.parse(
        '${ApiConfig.baseUrl}/report/squad-hours?squadId=${squadId.value}&startDate=$start&endDate=$end',
      );
      final resMembers = await http.get(urlMembers);

      if (resMembers.statusCode == 200) {
        final List data = json.decode(resMembers.body);
        reports.value = data.map((e) => SquadReportModel.fromJson(e)).toList();
      } else {
        reports.clear();
      }

      //Total de horas
      await fetchTotalHours(start, end);

      //Média de horas/dia
      await fetchAveragePerDay(start, end);
    } catch (e) {
      reports.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Total de horas da squad
  Future<void> fetchTotalHours(String start, String end) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/report/squad-total?squadId=${squadId.value}&startDate=$start&endDate=$end',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      totalHours.value =
          double.tryParse(data['totalHours']?.toString() ?? '0') ?? 0.0;
    } else {
      totalHours.value = 0.0;
    }
  }

  // Média diária de horas da squad
  Future<void> fetchAveragePerDay(String start, String end) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/report/squad-average?squadId=${squadId.value}&startDate=$start&endDate=$end',
    );
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      averagePerDay.value =
          double.tryParse(data['averagePerDay']?.toString() ?? '0') ?? 0.0;
    } else {
      averagePerDay.value = 0.0;
    }
  }
}
