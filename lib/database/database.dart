import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:notes/flutter.dart'
    show BuildContext, InheritedProviderSelector;

import 'package:parchment/parchment.dart';
import 'package:path_provider/path_provider.dart';

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
      await customStatement("DROP TRIGGER IF EXISTS notes_update;");
      await customStatement(
        "CREATE TRIGGER IF NOT EXISTS notes_update AFTER UPDATE ON notes BEGIN "
        "DELETE FROM notes_fts WHERE rowid = old.id; "
        "INSERT INTO notes_fts (rowid, title, content_text) VALUES (new.id, new.title, new.content_text); "
        "END;",
      );
      await customStatement("DROP TRIGGER IF EXISTS todos_update;");
      await customStatement(
        "CREATE TRIGGER IF NOT EXISTS todos_update AFTER UPDATE ON todos BEGIN "
        "DELETE FROM todos_fts WHERE rowid = old.id; "
        "INSERT INTO todos_fts (rowid, label, details) VALUES (new.id, new.label, new.details); "
        "END;",
      );
      await IsarToDriftMigrator.tryMigrate(this);
      await customStatement("PRAGMA foreign_keys = ON");
    },
  );

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
    notes.id.equalsExp(notesFts.rowId()),
    notesFts.matchExp(searchQuery),
    (row) => row.readTable(notes),
    searchQuery: searchQuery,
    orderBy: orderBy,
    limit: limit,
  );

  static String sanitizeFts5Query(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return "";

    final words = trimmed.split(RegExp(r"\s+"));
    final sanitizedWords = <String>[];

    for (final word in words) {
      if (word.isEmpty) continue;
      final escaped = word.replaceAll("\"", "\"\"");
      sanitizedWords.add("\"$escaped\"*");
    }

    return sanitizedWords.join(" ");
  }

  MultiSelectable<Note> searchNotes(
    String searchQuery, {
    OrderBy? Function(Notes notes, NotesFts notesFts)? orderBy,
    Limit? Function(Notes notes, NotesFts notesFts)? limit,
  }) {
    final sanitized = sanitizeFts5Query(searchQuery);
    if (sanitized.isEmpty) {
      final query = select(notes);
      if (limit?.call(notes, notesFts) case Limit(
        :final amount,
        :final offset,
      )) {
        query.limit(amount, offset: offset);
      }
      return query;
    }
    return searchNotesExp(Variable(sanitized), orderBy: orderBy, limit: limit);
  }

  MultiSelectable<Todo> searchTodosExp(
    Expression<String> searchQuery, {
    OrderBy? Function(Todos todos, TodosFts todosFts)? orderBy,
    Limit? Function(Todos todos, TodosFts todosFts)? limit,
  }) => _searchUnsafe(
    todos,
    todosFts,
    todos.id.equalsExp(todosFts.rowId()),
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
  }) {
    final sanitized = sanitizeFts5Query(searchQuery);
    if (sanitized.isEmpty) {
      final query = select(todos);
      if (limit?.call(todos, todosFts) case Limit(
        :final amount,
        :final offset,
      )) {
        query.limit(amount, offset: offset);
      }
      return query;
    }
    return searchTodosExp(Variable(sanitized), orderBy: orderBy, limit: limit);
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: "notes_database",
      native: const .new(databaseDirectory: getApplicationSupportDirectory),
    );
  }

  static const _selector = InheritedProviderSelector<AppDatabase>();

  static AppDatabase? maybeOf(BuildContext context, {bool listen = true}) =>
      _selector.maybeOf(context, listen: listen);

  static AppDatabase of(BuildContext context, {bool listen = true}) =>
      _selector.of(context, listen: listen);

  static T maybeAspectOf<T extends Object?>(
    BuildContext context,
    T Function(AppDatabase? database) selector, {
    bool listen = true,
  }) => _selector.maybeAspectOf(context, selector, listen: listen);

  static T aspectOf<T extends Object?>(
    BuildContext context,
    T Function(AppDatabase database) selector, {
    bool listen = true,
  }) => _selector.aspectOf(context, selector, listen: listen);
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
  GeneratedColumn<int> ftsRowIdUnsafe() =>
      .new("rowid", aliasedName, false, type: DriftSqlType.int);

  Expression<bool> ftsMatchExpUnsafe(Expression searchQuery) =>
      _FtsMatchExpression<TableType, RowType>(this, searchQuery);

  Expression<bool> ftsMatchUnsafe(String searchQuery) =>
      ftsMatchExpUnsafe(Variable(searchQuery));

  Expression<double> ftsBm25Unsafe({List<double> weights = const []}) =>
      _FtsBm25Expression(this, weights: weights);
}

extension NotesFtsExtension on NotesFts {
  GeneratedColumn<int> rowId() => ftsRowIdUnsafe();

  Expression<bool> matchExp(Expression searchQuery) =>
      ftsMatchExpUnsafe(searchQuery);

  Expression<bool> match(String searchQuery) => matchExp(Variable(searchQuery));

  Expression<double> bm25() => ftsBm25Unsafe();

  Expression<double> bm25Weighted(double title, double contentText) =>
      ftsBm25Unsafe(weights: [title, contentText]);
}

extension TodosFtsExtension on TodosFts {
  GeneratedColumn<int> rowId() => ftsRowIdUnsafe();

  Expression<bool> matchExp(Expression searchQuery) =>
      ftsMatchExpUnsafe(searchQuery);

  Expression<bool> match(String searchQuery) => matchExp(Variable(searchQuery));

  Expression<double> bm25() => ftsBm25Unsafe();

  Expression<double> bm25Weighted(double label, double details) =>
      ftsBm25Unsafe(weights: [label, details]);
}
