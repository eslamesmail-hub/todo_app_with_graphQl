import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app_with_graphql/schemas/get_tasks_schema.dart';
import 'package:todo_app_with_graphql/schemas/url_end_point.dart';

class GetTaskProvider extends ChangeNotifier {
  bool _status = false;
  String _response = '';

  dynamic _list = [];

  bool get getStatus => _status;
  String get getResponse => _response;

  EndPoint _point = EndPoint();

  void getTask(bool isLocal) async {
    ValueNotifier<GraphQLClient> _client = _point.getClient();

    QueryResult result = await _client.value.query(QueryOptions(
      document: gql(GetTaskSchema.getTaskJson),
      fetchPolicy: isLocal == true ? null : FetchPolicy.networkOnly,
    ));
    if (result.hasException) {
      print(result.exception);
      _status = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = 'Please check your internet';
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      print(result.data);
      _status = false;
      _list = result.data;
      _response = 'Task was successfully added';
      notifyListeners();
    }
  }

  dynamic getResponseData() {
    if (_list.isNotEmpty) {
      final data = _list;
      print(data['getTodos']);
      return data['getTodos'] ?? {};
    } else {
      return {};
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
