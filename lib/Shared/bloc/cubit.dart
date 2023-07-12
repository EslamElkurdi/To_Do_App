import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/bloc/states.dart';

import '../../Modules/archived_tasks.dart';
import '../../Modules/done_tasks.dart';
import '../../Modules/new_tasks.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates>
{
  ToDoAppCubit() : super(AppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<Widget> titleScreen =
  [
    Text("New Tasks"),
    Text("Done Tasks"),
    Text("Archived Tasks"),
  ];

  changeIndex(index)
  {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

}