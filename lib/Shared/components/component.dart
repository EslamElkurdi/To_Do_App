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

Widget buildTaskItem(Map model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children:
    [
      CircleAvatar(
        radius: 40,
        child: Text("${model['time']}"),
      ),
      SizedBox(
        width: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${model['title']}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
          Text(
            "${model['date']}",
            style: TextStyle(
                color: Colors.grey
            ),
          )
        ],
      )
    ],
  ),
);