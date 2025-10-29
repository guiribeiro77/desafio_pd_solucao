import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/controllers/employee_controller.dart';
import 'package:pd_hours_control/src/common_widgets/custom_textformfield.dart';

class AddEmployeeDialog {
  static Future<bool?> show() async {
    final employeeController = Get.find<EmployeeController>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final hoursController = TextEditingController();
    int? selectedSquadId;

    await employeeController.fetchSquads();

    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: Get.size.width * 0.35,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Adicionar Usuário',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Nome
                  CustomTextFormField(
                    controller: nameController,
                    labelText: 'Nome',
                    hintText: 'Digite o nome do usuário',
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Informe o nome'
                                : null,
                  ),
                  const SizedBox(height: 12),

                  // Horas estimadas
                  CustomTextFormField(
                    controller: hoursController,
                    labelText: 'Horas estimadas',
                    hintText: 'Digite as horas estimadas',
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Informe as horas estimadas';
                      }
                      final parsed = double.tryParse(val);
                      if (parsed == null || parsed <= 0) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Dropdown de squads
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Selecione a Squad',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          employeeController.squads
                              .map(
                                (s) => DropdownMenuItem<int>(
                                  value: s.id,
                                  child: Text(s.name),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => selectedSquadId = val,
                      validator:
                          (val) => val == null ? 'Selecione uma squad' : null,
                    );
                  }),
                  const SizedBox(height: 20),

                  // Botão de salvar
                  Center(
                    child: Obx(() {
                      return FilledButton(
                        onPressed:
                            employeeController.isLoading.value
                                ? null
                                : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  if (selectedSquadId == null) return;

                                  await employeeController.addEmployee(
                                    name: nameController.text.trim(),
                                    estimatedHours: double.parse(
                                      hoursController.text.trim(),
                                    ),
                                    squadId: selectedSquadId!,
                                  );
                                },
                        child:
                            employeeController.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Criar Usuário'),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
