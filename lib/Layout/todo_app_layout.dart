import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Modules/done_tasks.dart';
import 'package:todoapp/Shared/bloc/cubit.dart';
import 'package:todoapp/Shared/bloc/states.dart';
import 'package:todoapp/Shared/components/component.dart';

import '../Modules/archived_tasks.dart';
import '../Modules/new_tasks.dart';
import '../Shared/constants/constants.dart';

class ToDoApp extends StatelessWidget
{


  late Database database;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;

  Icon fabIcon = Icon(Icons.edit);

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();



  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   createDataBase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoAppCubit(),
      child: BlocConsumer<ToDoAppCubit, ToDoAppStates>(
        listener: (context, state){},
        builder: (context, state)
        {

          ToDoAppCubit cubit = ToDoAppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: cubit.titleScreen[cubit.currentIndex],
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if(isBottomSheetShown){

                    if(formKey.currentState!.validate()){

                      insertToDatabase(title: titleController.text, date: dateController.text, time: timeController.text)
                          .then((value){
                        Navigator.pop(context);
                        isBottomSheetShown = false;
                        // setState(() {
                        //   fabIcon = Icon(Icons.edit);
                        // });
                      });


                    }
                  }else{
                    scaffoldKey.currentState?.showBottomSheet(
                        elevation: 15,
                            (context) => Container(
                          padding:const EdgeInsets.all(20),
                          color: Colors.grey[250],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'Title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Title Task',
                                    prefIcon: Icons.title
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    onTapFunction: ()
                                    {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      ).then((value){
                                        timeController.text = value!.format(context).toString();
                                      });
                                    },
                                    label: 'Time Task',
                                    prefIcon: Icons.watch_later
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTapFunction: ()
                                    {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2022),
                                          lastDate: DateTime(2025)
                                      ).then((value)
                                      {
                                        // print(DateFormat.yMMMd().format(value));
                                        dateController.text = DateFormat.yMMMd().format(value!);

                                      });
                                    },
                                    label: 'Date Task',
                                    prefIcon: Icons.watch_later
                                ),
                              ],
                            ),
                          ),
                        )
                    ).closed.then((value){
                      isBottomSheetShown = false;
                      // setState(() {
                      //   fabIcon = Icon(Icons.edit);
                      // });
                    });
                    isBottomSheetShown = true;
                    // setState(() {
                    //   fabIcon = Icon(Icons.add);
                    // });
                  }
                },
                child: fabIcon

            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index){
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: const
              [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void createDataBase() async
  {
    database = await openDatabase(

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
          print("Database is opened");

          getDataFromDatabase(database).then((value){
            print(value);
            taskResult = value;
            print(taskResult);
          });
        }
    );
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time
  }) async
  {
    return await database.transaction((txn) async {
      txn.rawInsert("INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'New Task')")
          .then((value){
        print("Item is Inserted Successfully ${value.toString()}");
      }).catchError((error){
        print("Error is happened ${error.toString()}");

      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}


