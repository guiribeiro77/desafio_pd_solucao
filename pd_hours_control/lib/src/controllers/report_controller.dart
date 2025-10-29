import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pd_hours_control/src/configs/api_config.dart';
import 'package:pd_hours_control/src/common_widgets/custom_snackbar.dart';
import 'package:pd_hours_control/src/models/report_model.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;
  var reports = <ReportModel>[].obs;

  // Criar relatório
  Future<void> addReport({
    required int employeeId,
    required double spentHours,
    required String description,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/report'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'employeeId': employeeId,
          'spentHours': spentHours,
          'description': description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        final data = json.decode(response.body);
        reports.add(ReportModel.fromJson(data));
        showSuccess('Hora lançada com sucesso!');
      } else {
        Get.back();
        showError('Erro ao criar relatório. Tente novamente.');
      }
    } catch (e) {
      Get.back();
      showError('Erro ao criar relatório. Verifique sua conexão.');
    } finally {
      isLoading.value = false;
    }
  }
}
