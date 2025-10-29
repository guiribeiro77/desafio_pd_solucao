import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/common_widgets/custom_textformfield.dart';
import 'package:pd_hours_control/src/controllers/squad_controller.dart';

class AddSquadDialog {
  static void show() {
    final squadController = Get.find<SquadController>();
    final TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final size = Get.size;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: size.width * 0.2,
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
                      'Criar Squad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: nameController,
                      labelText: 'Nome da Squad',
                      hintText: 'Digite o nome da squad',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome da squad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: FilledButton(
                        onPressed:
                            squadController.isLoading.value
                                ? null
                                : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  final name = nameController.text.trim();
                                  await squadController.addSquad(name);
                                },
                        child:
                            squadController.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Criar Squad'),
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
