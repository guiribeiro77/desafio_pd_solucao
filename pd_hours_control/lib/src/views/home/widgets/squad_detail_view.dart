import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pd_hours_control/src/common_widgets/empty_card.dart';
import 'package:pd_hours_control/src/common_widgets/info_card.dart';
import 'package:pd_hours_control/src/controllers/squad_controller.dart';
import 'package:pd_hours_control/src/controllers/squad_report_controller.dart';
import 'package:pd_hours_control/src/views/home/widgets/add_employee_modal.dart';

class SquadDetailView extends StatelessWidget {
  final int squadId;
  final String squadName;
  final VoidCallback onBack;

  final squadReportController = Get.find<SquadReportController>();
  final squadController = Get.find<SquadController>();

  SquadDetailView({
    super.key,
    required this.squadId,
    required this.squadName,
    required this.onBack,
  }) {
    squadReportController.squadId.value = squadId;
    squadReportController.squadName.value = squadName;
    squadReportController.fetchSquadReports();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate =
        isStart
            ? squadReportController.startDate.value
            : squadReportController.endDate.value;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isStart) {
        squadReportController.startDate.value = picked;
      } else {
        squadReportController.endDate.value = picked;
      }
      await squadReportController.fetchSquadReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dateFormat = DateFormat('dd/MM/yyyy');

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  squadName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Seletor de datas
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    'Início: ${dateFormat.format(squadReportController.startDate.value)}',
                  ),
                  onPressed: () => _selectDate(context, true),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    'Fim: ${dateFormat.format(squadReportController.endDate.value)}',
                  ),
                  onPressed: () => _selectDate(context, false),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Conteúdo principal (reativo)
            Expanded(
              child: Obx(() {
                if (squadReportController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final employees =
                    squadController.employeesBySquad[squadId] ?? [];

                // Caso 1 — squad sem usuários
                if (employees.isEmpty) {
                  return EmptyCard(
                    icon: Icons.sentiment_dissatisfied_sharp,
                    title: 'Nenhum usuário na squad',
                    message:
                        'Adicione um usuário para começar a lançar horas nesta squad.',
                    actionLabel: 'Adicionar Usuário',
                    onAction: () async {
                      final created = await AddEmployeeDialog.show();
                      if (created == true) {
                        await squadController.loadEmployees();
                        await squadReportController.fetchSquadReports();
                      }
                    },
                  );
                }

                // Caso 2 — há usuários, mas sem horas lançadas
                final allZero = squadReportController.reports.every(
                  (r) => r.totalSpentHours == 0,
                );

                if (squadReportController.reports.isEmpty || allZero) {
                  return EmptyCard(
                    icon: Icons.sentiment_dissatisfied_sharp,
                    title: 'Nenhuma hora lançada',
                    message:
                        'Não há horas registradas neste período.\nTente selecionar outra data.',
                    actionLabel: 'Selecionar outro período',
                    onAction: () => _selectDate(context, false),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Tabela de relatórios
                      DataTable(
                        headingRowColor: WidgetStatePropertyAll(
                          Colors.deepPurple,
                        ),
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          width: 0.8,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Membro',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Descrição',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Horas Gastas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Criado em',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows:
                            squadReportController.reports
                                .where((r) => r.totalSpentHours > 0)
                                .map((report) {
                                  final createdAt = dateFormat.format(
                                    report.createdAt,
                                  );
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(report.employeeName)),
                                      DataCell(Text(report.description ?? '-')),
                                      DataCell(
                                        Text(
                                          '${report.totalSpentHours.toStringAsFixed(1)} h',
                                        ),
                                      ),
                                      DataCell(Text(createdAt)),
                                    ],
                                  );
                                })
                                .toList(),
                      ),

                      const SizedBox(height: 20),

                      // Indicadores de horas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InfoCard(
                            title: 'Horas Totais',
                            value: squadReportController.totalHours.value
                                .toStringAsFixed(1),
                          ),
                          InfoCard(
                            title: 'Média por Dia',
                            value: squadReportController.averagePerDay.value
                                .toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
