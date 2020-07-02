library graphql_fragment_generator;
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/graphql_fragment_generator.dart';

Builder graphQLFragmentBuilder(BuilderOptions options) =>
    PartBuilder([GraphQLFragmentGenerator()], ".graphql.g.dart");
