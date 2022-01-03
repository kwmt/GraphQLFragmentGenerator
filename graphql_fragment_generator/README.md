# GraphQL Fragment Generator

You can generate a fragment of GraphQL.

## Example

Given a library timeline.dart with a Timeline class and user.dart   with a User class both annotated with @GraphQLFragment():

```
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
```

```
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
```

Building creates the corresponding part `timeline.graphql.g.dart` and `user.graphql.g.dart`:

```
part of 'timeline.dart';

const String timelineFragmentName = "timelineField";
const String timelineFragment = '''
fragment $timelineFragmentName on timeline {
   id
   content
   user { ...$userFragmentName }
}
$userFragment
''';
```

```
part of 'user.dart';

const String userFragmentName = "userField";
const String userFragment = '''
fragment $userFragmentName on user {
   id
   name
}
''';
```

