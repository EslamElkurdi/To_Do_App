import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validate,
  required String label,
  required IconData prefIcon,
  Function? onTapFunction()?,
  IconData? sufx,
  Function? onChange(String? value)?,
  bool secureText = false,
  Function? onTapSuff()?,
  String? Function(String?)? onSubmit
}) =>
    TextFormField(

      validator: validate,

      keyboardType: type,
      controller: controller,
      onTap: onTapFunction,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      obscureText: secureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefIcon,
        ),
        labelText: label,
        suffixIcon: sufx != null
            ? IconButton(
          icon: Icon(sufx),
          onPressed: onTapSuff,
        )
            : null,
      ),
    );