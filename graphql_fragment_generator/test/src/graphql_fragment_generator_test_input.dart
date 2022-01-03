import 'package:graphql_fragment_annotation/graphql_fragment_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldGenerate(r"""
const String testClass1FragmentName = "testClass1Field";
final String testClass1Fragment = '''
fragment $testClass1FragmentName on testClass1 {
   h
}
''';
""",
  configurations: ['default'],
)
@GraphQLFragment(on: 'testClass1')
class TestClass1 {
  String firstName = "", lastName = "";
  @JsonKey(name: 'h')
  int height = 0;
  DateTime? dateOfBirth;
  dynamic dynamicType;

  //ignore: prefer_typing_uninitialized_variables
  var varType;
  List<int> listOfInts = List.empty();
}

@ShouldGenerate(r"""
const String testClass21FragmentName = "testClass21Field";
final String testClass21Fragment = '''
fragment $testClass21FragmentName on testClass21 {
   id
   testClass22 { ...$testClass22FragmentName }
   testClass22List { ...$testClass22FragmentName }
}
$testClass22Fragment
''';
""",
  configurations: ['default'],
)
@GraphQLFragment(on: 'testClass21')
class TestClass21 {
  @JsonKey(name: 'id')
  String id = "";
  @JsonKey(name: 'testClass22')
  TestClass22? testClass22 = null;

  @JsonKey(name: 'testClass22List')
  List<TestClass22> list = List.empty();
}

@ShouldGenerate(r"""
const String testClass22FragmentName = "testClass22Field";
final String testClass22Fragment = '''
fragment $testClass22FragmentName on testClass22 {
   id
}
''';
""",
  configurations: ['default'],
)
@GraphQLFragment(on: 'testClass22')
class TestClass22 {
  @JsonKey(name: 'id')
  String id = "";
}
