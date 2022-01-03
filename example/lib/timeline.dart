import 'package:graphql_fragment_annotation/graphql_fragment_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'timeline.graphql.g.dart';

@GraphQLFragment(on: "timeline")
class Timeline {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'content')
  final String name;
  @JsonKey(name: 'user')
  final User user;

  Timeline(this.id, this.name, this.user);
}
