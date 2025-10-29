import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/common_widgets/empty_card.dart';
import 'package:pd_hours_control/src/controllers/squad_controller.dart';
import 'package:pd_hours_control/src/controllers/squad_report_controller.dart';
import 'package:pd_hours_control/src/views/home/widgets/add_squad_modal.dart';

class SquadTab extends StatelessWidget {
  final void Function(int squadId, String squadName)? onVisitSquad;

  const SquadTab({super.key, this.onVisitSquad});

  @override
  Widget build(BuildContext context) {
    // final squadController = Get.put(SquadController());
    final squadController = Get.find<SquadController>();
    final squadReportController = Get.put(SquadReportController());

    return Obx(() {
      if (squadController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (squadController.squads.isEmpty) {
        return EmptyCard(
          icon: Icons.sentiment_dissatisfied_sharp,
          title: 'Nenhuma squad cadastrada ainda',
          message: 'Crie uma nova squad para começar a adicionar usuários.',
          actionLabel: 'Criar Squad',
          onAction: AddSquadDialog.show,
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Lista de Squads',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DataTable(
                    headingRowColor: const WidgetStatePropertyAll(
                      Colors.deepPurple,
                    ),
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 0.8,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Nome',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Ações',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows:
                        squadController.squads.map((squad) {
                          return DataRow(
                            cells: [
                              DataCell(Text(squad.id.toString())),
                              DataCell(Text(squad.name)),
                              DataCell(
                                FilledButton(
                                  onPressed: () {
                                    squadReportController.squadId.value =
                                        squad.id;
                                    squadReportController.squadName.value =
                                        squad.name;
                                    squadReportController.fetchSquadReports();

                                    onVisitSquad?.call(squad.id, squad.name);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'Visitar Squad',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: FilledButton.icon(
                  onPressed: AddSquadDialog.show,
                  icon: const Icon(Icons.add),
                  label: const Text('Criar Squad'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
