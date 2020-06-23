import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:graphql_annotation/graphql_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen/source_gen.dart';

class GraphQLFragmentGenerator extends GeneratorForAnnotation<GraphQLFragment> {
  final TypeChecker hasGraphQLFragment =
      TypeChecker.fromRuntime(GraphQLFragment);
  final TypeChecker hasJsonSerializable =
      TypeChecker.fromRuntime(JsonSerializable);
  final TypeChecker hasJsonKey = TypeChecker.fromRuntime(JsonKey);

//  @override
//  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
////    print("jsonKey: ${library.annotatedWithExact(hasJsonKey)}");
////    print("hasGraphQLFragment: ${library.annotatedWith(hasGraphQLFragment)}");
////    var lib = Library((b) => b
////      ..body.addAll(library
////          .annotatedWith(hasJsonKey)
////          .map((element) => Code(_codeForEnum(element)))));
////    final emitter = DartEmitter();
////    return lib.accept(emitter).toString();
//
////    final lib = Library((b) => b..body.addAll(library.element..map((e) => Code(_codeForEnum(e)))));
////    final emitter = DartEmitter();
////    return lib.accept(emitter).toString();
//  }
//
//  String _codeForEnum(AnnotatedElement element) {
//    return element.annotation.read("name").stringValue;
//  }

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }

    final classElement = element as ClassElement;
    print(classElement);

    var type = hasGraphQLFragment
        .firstAnnotationOfExact(classElement)
        .getField("on")
        .toStringValue();

    final elementInstanceFields =
        classElement.fields.where((e) => !e.isStatic).toList();

    print(elementInstanceFields);
//    elementInstanceFields[0].declaration.

    List<DartObject> jsonKeyFields = elementInstanceFields
        .map((e) => hasJsonKey.firstAnnotationOfExact(e))
        .where((element) => element != null)
        .toList();

    //elementInstanceFields[0].context
    StringBuffer buffer = StringBuffer();

    var lowerCaseClassName = _lowerCaseFirstLetter(classElement.name);
    var fragmentName = "${lowerCaseClassName}FragmentName";

    buffer.write('const String $fragmentName = \"${type}Field\";');
    buffer
      ..write('const String ${lowerCaseClassName}Fragment = \"\"\"\n')
      ..write('fragment \$$fragmentName on $type {\n')
      ..writeAll(jsonKeyFields.map((e) {
        return '   ${e.getField('name').toStringValue()}\n';
      }))
      ..write('}\n')
      ..write('\"\"\";');

    return Future.value(buffer.toString());
  }
  String _lowerCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toLowerCase()}${word.substring(1)}';
  }
}
