import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:fleather/fleather.dart';
import 'package:parchment/parchment.dart';

part 'note.g.dart';

@collection
class Note {
  Note();

  Note.withId({
    required this.id,
    required this.title,
    ParchmentDocument? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.favorite = false,
  })  : content = content ?? ParchmentDocument(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  late int id;

  @index
  late String title;

  @ignore
  late ParchmentDocument content;

  List<dynamic> get contentData => content.toDelta().toJson();
  set contentData(List<dynamic> value) {
    content = ParchmentDocument.fromJson(value);
  }

  @index
  String get contentText => content.toPlainText();

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool favorite;

  @ignore
  @override
  int get hashCode => Object.hash(
        id,
        title,
        content,
        createdAt,
        updatedAt,
      );

  @override
  bool operator ==(Object other) {
    return other is Note &&
        id == other.id &&
        title == other.title &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        contentData.equals(other.contentData);
  }
}
