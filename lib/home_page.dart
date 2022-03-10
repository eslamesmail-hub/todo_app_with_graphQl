import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/providers/add_task_provider.dart';
import 'package:todo_app_with_graphql/providers/delete_task_provider.dart';
import 'package:todo_app_with_graphql/providers/get_task_provider.dart';

import 'add_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFetched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Home'),
      ),
      body: Consumer<GetTaskProvider>(builder: (context, task, child) {
        if (isFetched == false) {
          ///Fetch the data
          task.getTask(true);
          Future.delayed(const Duration(seconds: 3), () => isFetched = true);
        } else if (Provider.of<DeleteTaskProvider>(context).getResponse ==
            'Task was successfully deleted') {
          Provider.of<GetTaskProvider>(context).getTask(false);
        } else if (Provider.of<AddTaskProvider>(context).getResponse ==
            'Task was successfully added') {
          Provider.of<GetTaskProvider>(context).getTask(false);
        }
        return RefreshIndicator(
          onRefresh: () {
            task.getTask(false);
            return Future.delayed(const Duration(seconds: 3));
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text("Available todo"),
              ),
              if (task.getResponseData().isEmpty) const Text('No Todo found'),
              Expanded(
                  child: ListView(
                children: List.generate(task.getResponseData().length, (index) {
                  final data = task.getResponseData()[index];
                  final dateFormat = DateFormat("dd-MM-yyyy")
                      .format(DateTime.parse(data['timeAdded']));
                  return ListTile(
                    title: Text(data['task']),
                    subtitle: Text(dateFormat),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(data['id'].toString()),
                    ),
                    trailing: Consumer<DeleteTaskProvider>(
                        builder: (context, delete, child) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (delete.getResponse != '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(delete.getResponse)));

                          delete.clear();
                        }
                      });
                      return IconButton(
                          onPressed: () {
                            ///Delete task
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "Are you sure you want to delete task?"),
                              action: SnackBarAction(
                                  label: "Delete Now",
                                  onPressed: () {
                                    delete.deleteTask(todoId: data['id']);
                                  }),
                            ));
                          },
                          icon: const Icon(Icons.delete));
                    }),
                  );
                }),
              )),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddTodo()));
          },
          label: const Text('Add Todo')),
    );
  }
}
