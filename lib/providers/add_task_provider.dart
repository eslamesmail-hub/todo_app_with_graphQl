import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app_with_graphql/schemas/add_task_schema.dart';
import 'package:todo_app_with_graphql/schemas/url_end_point.dart';

class AddTaskProvider extends ChangeNotifier {
  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  EndPoint _point = EndPoint();

  void addTask({
    String? task,
    String? status,
  }) async {
    print('add task');
    _status = true;
    _response = 'Please wait...';
    notifyListeners();

    ValueNotifier<GraphQLClient> _client = _point.getClient();

    QueryResult result = await _client.value.mutate(
        MutationOptions(document: gql(AddTaskSchema.addTaskJson), variables: {
      'task': task,
      'status': status,
    }));
    if (result.hasException) {
      _status = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = 'Please check your internet';
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      _status = false;
      _response = 'Task was successfully added';
      notifyListeners();
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
