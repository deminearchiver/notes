import 'package:collection/collection.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:notes/flutter.dart';

extension SortExtension on Sort {
  Sort reverse() => switch (this) {
    Sort.asc => Sort.desc,
    Sort.desc => Sort.asc,
  };
}
