import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pd_hours_control/src/common_widgets/custom_snackbar.dart';
import 'package:pd_hours_control/src/configs/api_config.dart';
import 'package:pd_hours_control/src/models/employee_model.dart';
import 'package:pd_hours_control/src/models/squad_model.dart';

class SquadController extends GetxController {
  // Lista de squads e estado de carregamento
  final squads = <SquadModel>[].obs;
  final isLoading = false.obs;

  // Lista geral de funcionários
  final employees = <EmployeeModel>[].obs;

  // Mapa: squadId → lista de funcionários
  final employeesBySquad = <int, List<EmployeeModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadSquads();
    loadEmployees();
  }

  // Cria uma nova squad
  Future<void> addSquad(String name) async {
    if (name.isEmpty) {
      Get.snackbar('Erro', 'Informe o nome da squad');
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/squad');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (Get.isDialogOpen == true) Get.back();

        final data = jsonDecode(response.body);
        final squad = SquadModel.fromJson(data);
        squads.add(squad);

        showSuccess('Squad "${squad.name}" criada com sucesso!');
      } else {
        final errorData = jsonDecode(response.body);
        final msg = errorData['message'] ?? 'Erro desconhecido ao criar squad';
        showError('Falha ao criar squad: $msg');
      }
    } catch (e) {
      showError('Erro ao criar squad: $e');
      print('Erro ao criar squad: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Carrega todas as squads da API
  Future<void> loadSquads() async {
    try {
      isLoading.value = true;
      final url = Uri.parse('${ApiConfig.baseUrl}/squad');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        squads.value = data.map((e) => SquadModel.fromJson(e)).toList();
      } else {
        squads.clear();
      }
    } catch (e) {
      print('Erro ao carregar squads: $e');
      squads.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Carrega todos os funcionários
  Future<void> loadEmployees() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/employee');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        employees.value = data.map((e) => EmployeeModel.fromJson(e)).toList();

        _groupEmployeesBySquad();
      } else {
        employees.clear();
        employeesBySquad.clear();
      }
    } catch (e) {
      print('Erro ao carregar employees: $e');
      employees.clear();
      employeesBySquad.clear();
    }
  }

  // Atualiza o mapa de squadId → employees
  void _groupEmployeesBySquad() {
    final Map<int, List<EmployeeModel>> grouped = {};

    for (final emp in employees) {
      grouped.putIfAbsent(emp.squadId, () => []).add(emp);
    }

    employeesBySquad.assignAll(grouped);
  }

  // Retorna a lista de funcionários de uma squad específica
  List<EmployeeModel> getEmployeesBySquad(int squadId) {
    return employeesBySquad[squadId] ?? [];
  }
}
