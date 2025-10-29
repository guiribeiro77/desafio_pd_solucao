import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError(String message) {
  Get.snackbar(
    'Erro',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.withValues(alpha: .2),
    colorText: Colors.red[900],
    icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}

void showSuccess(String message) {
  Get.snackbar(
    'Sucesso',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.withValues(alpha: 0.2),
    colorText: Colors.green[900],
    icon: const Icon(Icons.check_circle, color: Colors.green),
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}
