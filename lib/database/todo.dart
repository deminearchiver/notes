import 'package:isar/isar.dart';
part 'todo.g.dart';

@collection
class Todo {
  Todo({
    this.id = Isar.autoIncrement,
    required this.label,
    this.details = "",
    required this.date,
    this.important = false,
    this.completed = false,
  });
  Todo.empty({
    this.id = Isar.autoIncrement,
    this.label = "",
    this.details = "",
    this.important = false,
    this.completed = false,
    DateTime? date,
  }) : date = date ?? DateTime.now().add(const Duration(days: 1));

  Id id;

  String label;

  @Index(caseSensitive: false)
  List<String> get labelWords => Isar.splitWords(label);

  String details;

  @Index(caseSensitive: false)
  List<String> get detailsWords => Isar.splitWords(details);

  bool important;
  bool completed;

  DateTime date;

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
