import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.hintText,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      enableSuggestions: enableSuggestions,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: _getFormatters(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        counterText: '',
      ),
    );
  }

  /// Se for campo numérico, aplica filtro para aceitar só dígitos e ponto.
  List<TextInputFormatter>? _getFormatters() {
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.numberWithOptions(decimal: true)) {
      return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
    }
    return null;
  }
}
