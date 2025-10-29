import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/controllers/employee_controller.dart';
import 'package:pd_hours_control/src/controllers/report_controller.dart';
import 'package:pd_hours_control/src/common_widgets/custom_textformfield.dart';

class AddReportDialog {
  static void show() {
    final employeeController = Get.find<EmployeeController>();
    final reportController = Get.find<ReportController>();
    final formKey = GlobalKey<FormState>();

    final TextEditingController hoursController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    RxInt? selectedEmployeeId = 0.obs;

    if (employeeController.employees.isEmpty) {
      employeeController.fetchEmployees();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: Get.size.width * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Lançar Horas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown de funcionários
                    DropdownButtonFormField<int>(
                      value:
                          selectedEmployeeId.value == 0
                              ? null
                              : selectedEmployeeId.value,
                      decoration: const InputDecoration(
                        labelText: 'Funcionário',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          employeeController.employees
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => selectedEmployeeId.value = value!,
                      validator:
                          (value) =>
                              value == null ? 'Selecione um funcionário' : null,
                    ),
                    const SizedBox(height: 16),

                    // Horas gastas
                    CustomTextFormField(
                      controller: hoursController,
                      labelText: 'Horas gastas',
                      hintText: 'Digite o número de horas',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Informe as horas gastas';
                        if (double.tryParse(value) == null)
                          return 'Digite um número válido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descrição
                    CustomTextFormField(
                      controller: descriptionController,
                      labelText: 'Descrição',
                      hintText: 'Digite a descrição do trabalho',
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? 'Informe a descrição'
                                  : null,
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),

                    // Botão criar
                    Center(
                      child: FilledButton(
                        onPressed:
                            reportController.isLoading.value
                                ? null
                                : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  await reportController.addReport(
                                    employeeId: selectedEmployeeId.value,
                                    spentHours: double.parse(
                                      hoursController.text,
                                    ),
                                    description:
                                        descriptionController.text.trim(),
                                  );
                                },
                        child:
                            reportController.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Lançar Horas'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
