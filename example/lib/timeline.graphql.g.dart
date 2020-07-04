// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// GraphQLFragmentGenerator
// **************************************************************************

const String timelineFragmentName = "timelineField";
const String timelineFragment = '''
fragment $timelineFragmentName on timeline {
   id
   content
   user { ...$userFragmentName }
}
$userFragment
''';
