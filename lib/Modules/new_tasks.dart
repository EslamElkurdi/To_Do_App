import 'package:flutter/material.dart';
import 'package:todoapp/Shared/components/component.dart';

import '../Shared/constants/constants.dart';
class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(taskResult![index]),
        separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20,
            ),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        itemCount: taskResult!.length
    );
  }
}
