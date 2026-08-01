import 'dart:io';

import 'package:isar_plus/isar_plus.dart';
import 'package:parchment/parchment.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'isar/note.dart';
import 'isar/todo.dart';

abstract final class IsarToDriftMigrator {
  static const _migratedKey = "migrated_isar_v0_to_drift_v1";

  static Future<Isar?> _tryOpenIsarIfExists() async {
    final directory = await getApplicationSupportDirectory();

    final isarFile = File(p.join(directory.path, "default.isar"));
    if (!isarFile.existsSync()) return null;

    try {
      return Isar.open(
        schemas: [NoteSchema, TodoSchema],
        directory: directory.path,
      );
    } on Object {
      return null;
    }
  }

  static Future<bool> tryMigrate(AppDatabase drift) async {
    final sharedPreferencesAsync = SharedPreferencesAsync();
    Future<bool> getMigrated() async =>
        await sharedPreferencesAsync.getBool(_migratedKey) ?? false;

    Future<void> setMigrated(bool value) =>
        sharedPreferencesAsync.setBool(_migratedKey, value);

    if (await getMigrated()) return false;

    final isar = await _tryOpenIsarIfExists();
    if (isar == null) {
      await setMigrated(true);
      return true;
    }

    try {
      final (notes, todos) = isar.read((isar) {
        return (isar.notes.where().findAll(), isar.todos.where().findAll());
      });
      await drift.batch((batch) {
        for (final note in notes) {
          batch.insert(
            drift.notes,
            NotesCompanion.insert(
              id: .new(note.id),
              title: note.title,
              content: note.content,
              contentText: note.contentText,
              createdAt: note.createdAt,
              updatedAt: note.updatedAt,
              favorite: note.favorite,
            ),
            mode: .insertOrReplace,
          );
        }
        for (final todo in todos) {
          batch.insert(
            drift.todos,
            TodosCompanion.insert(
              id: .new(todo.id),
              label: todo.label,
              details: .new(todo.details),
              important: .new(todo.important),
              completed: .new(todo.completed),
              date: todo.date,
            ),
            mode: .insertOrReplace,
          );
        }
      });

      if (isar.isOpen) isar.close();

      await setMigrated(true);
      return true;
    } on Object catch (e, s) {
      if (isar.isOpen) isar.close();

      return false;
    }
  }
}
