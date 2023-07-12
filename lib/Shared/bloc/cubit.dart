import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
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

  late Database database;
  List<Map>? taskResult = [];

  changeIndex(index)
  {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  void createDataBase() async
  {
    openDatabase(

        "todo.db",
        version: 1,
        onCreate: (database, version)
        {
          print("Database is created");

          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
            print("Table is Created");
          }).catchError((error){
            print("Error while creating table ${error.toString()}");
          });
        },

        onOpen: (database)
        {
          emit(GetLoadingState());

          print("Database is opened");

          getDataFromDatabase(database).then((value){
            print(value);
            taskResult = value;
            print(taskResult);
            emit(GetDatabaseState());
          });
        }
    ).then((value){
        database = value;
        emit(CreateDatabaseState());

    });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time
  }) async
  {
    await database.transaction((txn) async {
      txn.rawInsert("INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'New Task')")
          .then((value){
        print("Item is Inserted Successfully ${value.toString()}");
        emit(InsertToDatabaseState());
        getDataFromDatabase(database).then((value){
          taskResult = value;
          print(taskResult);
          emit(GetDatabaseState());
        });

      }).catchError((error){
        print("Error is happened ${error.toString()}");

      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    emit(GetLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');


  }

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  changeBottomSheetShown({
    required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetShownState());
  }

}