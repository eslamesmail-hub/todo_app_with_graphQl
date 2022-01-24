import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app_with_graphql/utils/url.dart';

class EndPoint {
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> _client = ValueNotifier(GraphQLClient(
      link: HttpLink(endPointUrl),
      cache: GraphQLCache(store: HiveStore()),
    ));
    return _client;
  }
}
