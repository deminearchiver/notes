import 'package:collection/collection.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:material/material.dart';

extension SortExtension on Sort {
  Sort reverse() => switch (this) {
    Sort.asc => Sort.desc,
    Sort.desc => Sort.asc,
  };
}
