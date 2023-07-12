import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/bloc/cubit.dart';
import 'package:todoapp/Shared/bloc/states.dart';
import 'package:todoapp/Shared/components/component.dart';
import '../Shared/constants/constants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
        listener: (context, state){},
      builder: (context, state)
      {
        var tasks = ToDoAppCubit.get(context).newTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}
