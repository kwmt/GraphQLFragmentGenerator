library graphql_generator;
import 'package:build/build.dart';
import 'package:graphql_generator/src/enum_has_value_generator.dart';
import 'package:graphql_generator/src/graphql_fragment_generator.dart';
import 'package:source_gen/source_gen.dart';


//Builder enumHasValueBuilder(BuilderOptions options) =>
//    PartBuilder([EnumHasValueGenerator()], ".value.g.dart");
Builder graphQLFragmentBuilder(BuilderOptions options) =>
    PartBuilder([GraphQLFragmentGenerator()], ".graphql.g.dart");
