import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/common_widgets/empty_card.dart';
import 'package:pd_hours_control/src/controllers/employee_controller.dart';
import 'package:pd_hours_control/src/views/home/widgets/add_employee_modal.dart';

class EmployeeTab extends StatelessWidget {
  const EmployeeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.find<EmployeeController>();

    return FutureBuilder(
      future: Future.wait([
        employeeController.fetchSquads(),
        employeeController.fetchEmployees(),
      ]),
      builder: (context, snapshot) {
        return Obx(() {
          // Se não houver squads
          if (employeeController.squads.isEmpty) {
            return EmptyCard(
              icon: Icons.sentiment_dissatisfied_sharp,
              title: 'Nenhuma squad cadastrada',
              message:
                  'Você precisa criar uma squad antes de adicionar usuários.',
              actionLabel: '',
            );
          }

          // Loading
          if (employeeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Sem usuários
          if (employeeController.employees.isEmpty) {
            return EmptyCard(
              icon: Icons.sentiment_dissatisfied_sharp,
              title: 'Nenhum usuário cadastrado',
              message: 'Adicione um novo usuário para começar a lançar horas.',
              actionLabel: 'Adicionar Usuário',
              onAction: AddEmployeeDialog.show,
            );
          }

          // Quando houver usuários
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DataTable(
                    headingRowColor: WidgetStatePropertyAll(Colors.deepPurple),
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 0.8,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Nome',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Horas Estimadas',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Squad ID',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows:
                        employeeController.employees.map((employee) {
                          return DataRow(
                            cells: [
                              DataCell(Text(employee.name)),
                              DataCell(
                                Text(
                                  '${employee.estimatedHours.toStringAsFixed(1)} h',
                                ),
                              ),
                              DataCell(Text(employee.squadId.toString())),
                            ],
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: AddEmployeeDialog.show,
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Usuário'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
