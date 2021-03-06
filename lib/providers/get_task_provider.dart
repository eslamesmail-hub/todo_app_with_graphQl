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

  String? setResponse(String value) {
    return _response = value;
  }

  EndPoint _point = EndPoint();

  void getTask(bool isLocal) async {
    print('get task');
    ValueNotifier<GraphQLClient> _client = _point.getClient();

    QueryResult result = await _client.value.query(QueryOptions(
      document: gql(GetTaskSchema.getTaskJson),
      fetchPolicy: isLocal == true ? null : FetchPolicy.networkOnly,
    ));
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
      _list = result.data;
      print(_list);
      notifyListeners();
    }
  }

  dynamic getResponseData() {
    if (_list.isNotEmpty) {
      final data = _list;

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
