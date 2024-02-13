import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:fleather/fleather.dart';

part 'note.g.dart';

@collection
class Note {
  Note({
    this.id = Isar.autoIncrement,
    required this.title,
    ParchmentDocument? content,
    required this.createdAt,
    required this.updatedAt,
  }) : content = content ?? ParchmentDocument();

  Note.empty({
    this.id = Isar.autoIncrement,
    this.title = "",
  })  : content = ParchmentDocument(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  final Id id;

  String title;

  @Index(caseSensitive: false)
  List<String> get titleWords => Isar.splitWords(title);

  @ignore
  ParchmentDocument content;

  @Index(caseSensitive: false)
  List<String> get contentWords => Isar.splitWords(content.toPlainText());

  List<String> get contentData =>
      content.toDelta().toJson().map((e) => jsonEncode(e)).toList();
  set contentData(List<String> value) {
    content =
        ParchmentDocument.fromJson(value.map((e) => jsonDecode(e)).toList());
  }

  String get contentText => content.toPlainText();

  DateTime createdAt;
  DateTime updatedAt;

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
