import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:graphql_fragment_annotation/graphql_fragment_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen/source_gen.dart';

class GraphQLFragmentGenerator extends GeneratorForAnnotation<GraphQLFragment> {
  final TypeChecker hasGraphQLFragment =
      TypeChecker.fromRuntime(GraphQLFragment);
  final TypeChecker hasJsonKey = TypeChecker.fromRuntime(JsonKey);

  Set<ClassElement> _graphQLFragmentFields = Set();

  String get _graphQLFragmentFieldsString =>
      _graphQLFragmentFields.map((field) {
        return "\$${_createFragment(field.name)}";
      }).join("\n");

  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }

    final classElement = element as ClassElement;

    var type = hasGraphQLFragment
        .firstAnnotationOfExact(classElement)
        ?.getField("on")
        ?.toStringValue() ?? "";

    final elementInstanceFields =
        classElement.fields.where((e) => !e.isStatic).toList();

    List<FieldObject> jsonKeyFields = elementInstanceFields
        .map((e) {
          final jsonKeyObject = hasJsonKey.firstAnnotationOfExact(e);
          return FieldObject(jsonKeyObject, e);
        })
        .where((e) => e.dartObject != null)
        .toList();

    _graphQLFragmentFields.clear();

    yield _createGraphQLFragment(classElement, type, jsonKeyFields);
  }

  String _createGraphQLFragment(
      ClassElement classElement, String type, List<FieldObject> jsonKeyFields) {
    StringBuffer buffer = StringBuffer();

    final fragmentName = _createFragmentName(classElement.name);

    buffer.write('const String $fragmentName = \"${type}Field\";');
    buffer
      ..write("const String ${_createFragment(classElement.name)} = '''\n")
      ..write('fragment \$$fragmentName on $type {\n')
      ..writeAll(jsonKeyFields.map((e) => _generateField(e)))
      ..write('}\n')
      ..write(_graphQLFragmentFieldsString)
      ..write(_graphQLFragmentFields.isEmpty ? '' : '\n')
      ..write("''';");

    return buffer.toString();
  }

  /// ex) profile { ...$profileEntityFragmentName }
  String _generateField(FieldObject fieldObject) {
    ClassElement? classElement = fieldObject.classElement;

    final iterableClassElement = findIterableField(fieldObject);
    if (iterableClassElement != null) {
      classElement = iterableClassElement;
    }

    final graphqlFragment = findGraphQlFragmentFields(classElement);

    final onlyJsonKeyField =
        fieldObject.dartObject?.getField('name')?.toStringValue() ?? "";

    var graphqlFragmentString = "";
    if (graphqlFragment != null) {
      var fragmentName = _createFragmentName(graphqlFragment.name);
      graphqlFragmentString = " { ...\$$fragmentName }";
      // FragmentNameではなくてFragmentそのものを保存しておく
      _graphQLFragmentFields.add(graphqlFragment);
    }

    final field = "$onlyJsonKeyField$graphqlFragmentString";
    return "   $field\n";
  }

  /// フィールドのメタデータに@GraphQLFragmentアノテーションが付与されている場合、そのメタデータ情報を取得する。
  /// 付与されてなければ nullを返す。
  ClassElement? findGraphQlFragmentFields(ClassElement? element) {
    if (element == null) {
      return null;
    }

    final graphQlFragmentElement = element.metadata.singleWhereOrNull(
        (element) => element.element?.enclosingElement?.name == 'GraphQLFragment');
    // @GraphQLFragmentアノテーションが付与されていれば、その時のインスタンスフィールドを表示する。
    if (graphQlFragmentElement != null) {
      return element;
    }
    return null;
  }

  /// return [ClassElement] if element implements [Iterable] type. otherwise null
  ClassElement? findIterableField(FieldObject fieldObject) {
    final iterableField = fieldObject.classElement?.allSupertypes.singleWhereOrNull(
        (element) => element.isDartCoreIterable);

    if (iterableField != null) {
      final type = _getGenericTypes(fieldObject.fieldElement?.type);
      return type?.element is ClassElement ? type?.element as ClassElement : null;
    }
    return null;
  }

  String _lowerCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toLowerCase()}${word.substring(1)}';
  }

  String _createFragmentName(String className) {
    final lowerCaseClassName = _lowerCaseFirstLetter(className);
    return "${lowerCaseClassName}FragmentName";
  }

  String _createFragment(String className) {
    final lowerCaseClassName = _lowerCaseFirstLetter(className);
    return "${lowerCaseClassName}Fragment";
  }

  DartType? _getGenericTypes(DartType? type) {
    return type is ParameterizedType ? type.typeArguments.first : null;
  }
}

class FieldObject {
  final DartObject? dartObject;
  final FieldElement? fieldElement;

  FieldObject(this.dartObject, this.fieldElement);

  ClassElement? get classElement {
    if (fieldElement != null && fieldElement?.type.element is ClassElement) {
      return fieldElement?.type.element as ClassElement;
    }
    return null;
  }
}
