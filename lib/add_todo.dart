import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/providers/add_task_provider.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _task = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
      ),
      body: Consumer<AddTaskProvider>(
        builder: (BuildContext context, task, Widget? child) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (task.getResponse != '') {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(task.getResponse)));

              task.clear();
            }
          });
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text('Add your first todo'),
                    ),
                    TextFormField(
                      controller: _task,
                      decoration: const InputDecoration(
                        labelText: 'Todo Task',
                      ),
                    ),
                    GestureDetector(
                      onTap: task.getStatus == true
                          ? null
                          : () {
                              print(_task.text);
                              if (_task.text.isNotEmpty) {
                                task.addTask(
                                    task: _task.text.trim(), status: 'Pending');
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            color: task.getStatus == true
                                ? Colors.grey
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          task.getStatus == true ? 'Loading...' : 'Save Task',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
