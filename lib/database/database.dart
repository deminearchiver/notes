import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:notes/database/isar/note.dart';
import 'package:notes/database/isar/todo.dart';
import 'package:parchment/parchment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'isar_to_drift_migrator.dart';

part 'database.g.dart';

final parchmentJsonConverter = TypeConverter.json2<ParchmentDocument>(
  fromJson: (json) => switch (json) {
    List<Object?>() => .fromJson(json),
    _ => .new(),
  },
  toJson: (column) => column.toJson() as Object?,
);

@DriftDatabase(include: {"tables.drift"}, tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => .new(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      await customStatement("PRAGMA foreign_keys = OFF");

      // await m.runMigrationSteps(
      //   from: from,
      //   to: to,
      //   steps: (currentVersion, database) async => database.schemaVersion,
      // );

      var debugAssertsEnabled = false;
      assert(() {
        debugAssertsEnabled = true;
        return true;
      }());

      if (debugAssertsEnabled) {
        final wrongForeignKeys = await customSelect(
          "PRAGMA foreign_key_check",
        ).get();
        assert(
          wrongForeignKeys.isEmpty,
          "${wrongForeignKeys.map((row) => row.data)}",
        );
      }

      await customStatement("PRAGMA foreign_keys = ON");
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        print("Trying to migrate from Isar");
        await IsarToDriftMigrator.tryMigrate(this);
      }
      await customStatement("PRAGMA foreign_keys = ON");
    },
  );

  Future<void> _migrateFromIsarToDrift() async {}

  // Future<int> addNote(NotesCompanion entry) => into(notes).insert(entry);

  // Future<void> addNotes(Iterable<NotesCompanion> entries) => batch((batch) {
  //   batch.insertAll(notes, entries);
  // });

  // Future<int> addTodo(TodosCompanion entry) => into(todos).insert(entry);

  // Future<void> addTodos(Iterable<TodosCompanion> entries) => batch((batch) {
  //   batch.insertAll(notes, entries);
  // });

  SingleOrNullSelectable<Note> noteById(int id) =>
      (select(notes)..where((notes) => notes.id.equals(id)));

  SingleOrNullSelectable<Todo> todoById(int id) =>
      (select(todos)..where((todos) => todos.id.equals(id)));

  MultiSelectable<RowType> _searchUnsafe<
    TableType extends TableInfo<Table, RowType>,
    RowType extends Object,
    TableFtsType extends VirtualTableInfo<Table, RowFtsType>,
    RowFtsType extends Object
  >(
    TableType table,
    TableFtsType tableFts,
    Expression<bool> joinOn,
    Expression<bool> wherePredicate,
    RowType Function(TypedResult row) mapper, {
    required Expression<String> searchQuery,
    OrderBy? Function(TableType table, TableFtsType tableFts)? orderBy,
    Limit? Function(TableType table, TableFtsType tableFts)? limit,
  }) {
    final query = select(table).join([
      innerJoin(tableFts, joinOn, useColumns: false),
    ])..where(wherePredicate);

    if (orderBy?.call(table, tableFts) case OrderBy(:final terms)) {
      query.orderBy(terms);
    }

    if (limit?.call(table, tableFts) case Limit(:final amount, :final offset)) {
      query.limit(amount, offset: offset);
    }

    return query.map(mapper);
  }

  MultiSelectable<Note> searchNotesExp(
    Expression<String> searchQuery, {
    OrderBy? Function(Notes notes, NotesFts notesFts)? orderBy,
    Limit? Function(Notes notes, NotesFts notesFts)? limit,
  }) => _searchUnsafe(
    notes,
    notesFts,
    notes.id.equalsExp(notesFts.rowId),
    notesFts.matchExp(searchQuery),
    (row) => row.readTable(notes),
    searchQuery: searchQuery,
    orderBy: orderBy,
    limit: limit,
  );

  MultiSelectable<Note> searchNotes(
    String searchQuery, {
    OrderBy? Function(Notes notes, NotesFts notesFts)? orderBy,
    Limit? Function(Notes notes, NotesFts notesFts)? limit,
  }) => searchNotesExp(Variable(searchQuery), orderBy: orderBy, limit: limit);

  MultiSelectable<Todo> searchTodosExp(
    Expression<String> searchQuery, {
    OrderBy? Function(Todos todos, TodosFts todosFts)? orderBy,
    Limit? Function(Todos todos, TodosFts todosFts)? limit,
  }) => _searchUnsafe(
    todos,
    todosFts,
    todos.id.equalsExp(todosFts.rowId),
    todosFts.matchExp(searchQuery),
    (row) => row.readTable(todos),
    searchQuery: searchQuery,
    orderBy: orderBy,
    limit: limit,
  );

  MultiSelectable<Todo> searchTodos(
    String searchQuery, {
    OrderBy? Function(Todos todos, TodosFts todosFts)? orderBy,
    Limit? Function(Todos todos, TodosFts todosFts)? limit,
  }) => searchTodosExp(Variable(searchQuery), orderBy: orderBy, limit: limit);

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: "notes_database",
      native: const .new(databaseDirectory: getApplicationSupportDirectory),
    );
  }
}

class _FtsMatchExpression<
  TableType extends VirtualTableInfo<Table, RowType>,
  RowType extends Object
>
    extends Expression<bool> {
  const _FtsMatchExpression(this.table, this.searchQuery);

  final TableType table;

  final Expression searchQuery;

  @override
  Precedence get precedence => .comparisonEq;

  @override
  void writeInto(GenerationContext context) {
    context.buffer.write(context.identifier(table.actualTableName));
    context.writeWhitespace();
    context.buffer.write("MATCH");
    context.writeWhitespace();
    writeInner(context, searchQuery);
  }
}

class _FtsBm25Expression<
  TableType extends VirtualTableInfo<Table, RowType>,
  RowType extends Object
>
    extends Expression<double> {
  const _FtsBm25Expression(this.table, {this.weights = const []});

  final TableType table;

  final List<double> weights;

  @override
  void writeInto(GenerationContext context) {
    context.buffer.write("bm25(");
    context.buffer.write(context.identifier(table.actualTableName));
    if (weights.isNotEmpty) {
      context.buffer.write(", ");
      context.buffer.write(weights.join(", "));
    }
    context.buffer.write(")");
  }
}

extension FtsExtension<
  TableType extends VirtualTableInfo<Table, RowType>,
  RowType extends Object
>
    on TableType {
  Expression<bool> ftsMatchExpUnsafe(Expression searchQuery) =>
      _FtsMatchExpression<TableType, RowType>(this, searchQuery);

  Expression<bool> ftsMatchUnsafe(String searchQuery) =>
      ftsMatchExpUnsafe(Variable(searchQuery));

  Expression<double> ftsBm25Unsafe({List<double> weights = const []}) =>
      _FtsBm25Expression(this, weights: weights);
}

extension NotesFtsExtension on NotesFts {
  Expression<bool> matchExp(Expression searchQuery) =>
      ftsMatchExpUnsafe(searchQuery);

  Expression<bool> match(String searchQuery) => matchExp(Variable(searchQuery));

  Expression<double> bm25() => ftsBm25Unsafe();

  Expression<double> bm25Weighted(double title, double contentText) =>
      ftsBm25Unsafe(weights: [title, contentText]);
}

extension TodosFtsExtension on TodosFts {
  Expression<bool> matchExp(Expression searchQuery) =>
      ftsMatchExpUnsafe(searchQuery);

  Expression<bool> match(String searchQuery) => matchExp(Variable(searchQuery));

  Expression<double> bm25() => ftsBm25Unsafe();

  Expression<double> bm25Weighted(double label, double details) =>
      ftsBm25Unsafe(weights: [label, details]);
}
