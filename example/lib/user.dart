import 'package:graphql_fragment_annotation/graphql_fragment_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.graphql.g.dart';

@GraphQLFragment(on: 'user')
class User {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  User(this.id, this.name);
}

