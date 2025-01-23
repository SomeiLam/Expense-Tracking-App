import 'package:flutter/material.dart';

class OutlineInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String?>? onChanged;
  final List<DropdownMenuItem<String>>? items; // For dropdown usage
  final String? value; // For dropdown selected value
  final String? Function(String?)? validator;

  const OutlineInput({
    super.key,
    required this.labelText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
    this.items,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (items != null) {
      // Render Dropdown if items are provided
      return DropdownButtonFormField<String>(
        value: value,
        decoration: _getInputDecoration(),
        items: items,
        onChanged: onChanged,
        validator: validator,
      );
    }

    // Render TextField otherwise
    return TextFormField(
      controller: controller,
      decoration: _getInputDecoration(),
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.deepPurple, // Border color when focused
          width: 2.0, // Border width when focused
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.grey, // Border color when not focused
          width: 1.0, // Border width when not focused
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
