import 'package:graphql_fragment_generator/src/graphql_fragment_generator.dart';
import 'package:test/test.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  initializeBuildLogTracking();
  final reader = await initializeLibraryReaderForDirectory(
    p.join('test', 'src'),
    'graphql_fragment_generator_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    GraphQLFragmentGenerator(),
    expectedAnnotatedTests: _expectedAnnotatedTests,
  );
}

const _expectedAnnotatedTests = [
  'TestClass1',
  'TestClass21',
  'TestClass22',
];
