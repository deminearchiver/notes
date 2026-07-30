import 'package:isar_plus/isar_plus.dart';

extension SortExtension on Sort {
  Sort get flipped => switch (this) {
    .asc => .desc,
    .desc => .asc,
  };
}
