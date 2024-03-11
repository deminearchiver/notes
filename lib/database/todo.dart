import 'package:isar/isar.dart';
part 'todo.g.dart';

@collection
class Todo {
  late int id;

  @index
  late String label;
  @index
  late String details;

  late bool important;
  late bool completed;

  late DateTime date;

  @ignore
  @override
  int get hashCode => Object.hashAll([
        id,
        label,
        details,
        important,
        completed,
        date,
      ]);

  @override
  bool operator ==(Object other) {
    return other is Todo &&
        id == other.id &&
        label == other.label &&
        details == other.details &&
        important == other.important &&
        completed == other.completed &&
        date == other.date;
  }
}
