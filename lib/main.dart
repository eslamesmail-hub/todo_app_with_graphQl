import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/providers/add_task_provider.dart';
import 'package:todo_app_with_graphql/providers/delete_task_provider.dart';
import 'package:todo_app_with_graphql/providers/get_task_provider.dart';

import 'home_page.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddTaskProvider()),
        ChangeNotifierProvider(create: (_) => GetTaskProvider()),
        ChangeNotifierProvider(create: (_) => DeleteTaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App With GraphQl',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
