import 'package:flutter/material.dart';

Widget customTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String labelText,
  required IconData prefix,
  Function()? onTap,
  required String? Function(String?) validate,
  Widget? suffix,
  bool isObscureText = false,
}) {
  return TextFormField(
    onTap: onTap,
    validator: validate,
    controller: controller,
    obscureText: isObscureText,
    keyboardType: type,
    decoration: InputDecoration(
      labelText: labelText,
      suffixIcon: suffix,
      prefixIcon: Icon(prefix),
      border: const OutlineInputBorder(),
    ),
  );
}
