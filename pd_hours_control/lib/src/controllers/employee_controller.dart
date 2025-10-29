import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pd_hours_control/src/common_widgets/custom_snackbar.dart';
import 'package:pd_hours_control/src/configs/api_config.dart';
import 'package:pd_hours_control/src/controllers/squad_controller.dart';
import 'package:pd_hours_control/src/models/employee_model.dart';
import 'dart:convert';
import 'package:pd_hours_control/src/models/squad_model.dart';

class EmployeeController extends GetxController {
  var isLoading = false.obs;
  var employees = <EmployeeModel>[].obs;
  var squads = <SquadModel>[].obs;

  // Buscar squads
  Future<void> fetchSquads() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/squad'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        squads.value = data.map((e) => SquadModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Erro ao buscar squads: $e');
    }
  }

  // Criar usuário
  Future<void> addEmployee({
    required String name,
    required double estimatedHours,
    required int squadId,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/employee'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'estimatedHours': estimatedHours,
          'squadId': squadId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        final data = json.decode(response.body);
        employees.add(EmployeeModel.fromJson(data));
        showSuccess('Usuário criado com sucesso!');

        // Atualiza o SquadController para refletir o novo usuário
        try {
          final squadController = Get.find<SquadController>();
          await squadController.loadEmployees();
        } catch (_) {}

        isLoading.value = false;
      } else {
        Get.back();
        showError('Erro ao criar usuário. Tente novamente.');
        isLoading.value = false;
      }
    } catch (e) {
      Get.back();
      showError('Erro ao criar usuário. Verifique sua conexão.');
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/employee'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        employees.value = data.map((e) => EmployeeModel.fromJson(e)).toList();
      } else {
        showError('Erro ao buscar funcionários.');
      }
    } catch (e) {
      showError('Erro ao buscar funcionários. Verifique sua conexão.');
    }
  }
}
