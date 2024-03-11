// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetTodoCollection on Isar {
  IsarCollection<int, Todo> get todos => this.collection();
}

const TodoSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Todo',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'label',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'details',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'important',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'completed',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'date',
        type: IsarType.dateTime,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'label',
        properties: [
          "label",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'details',
        properties: [
          "details",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, Todo>(
    serialize: serializeTodo,
    deserialize: deserializeTodo,
    deserializeProperty: deserializeTodoProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeTodo(IsarWriter writer, Todo object) {
  IsarCore.writeString(writer, 1, object.label);
  IsarCore.writeString(writer, 2, object.details);
  IsarCore.writeBool(writer, 3, object.important);
  IsarCore.writeBool(writer, 4, object.completed);
  IsarCore.writeLong(writer, 5, object.date.toUtc().microsecondsSinceEpoch);
  return object.id;
}

@isarProtected
Todo deserializeTodo(IsarReader reader) {
  final object = Todo();
  object.id = IsarCore.readId(reader);
  object.label = IsarCore.readString(reader, 1) ?? '';
  object.details = IsarCore.readString(reader, 2) ?? '';
  object.important = IsarCore.readBool(reader, 3);
  object.completed = IsarCore.readBool(reader, 4);
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      object.date =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.date =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeTodoProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readBool(reader, 3);
    case 4:
      return IsarCore.readBool(reader, 4);
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _TodoUpdate {
  bool call({
    required int id,
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  });
}

class _TodoUpdateImpl implements _TodoUpdate {
  const _TodoUpdateImpl(this.collection);

  final IsarCollection<int, Todo> collection;

  @override
  bool call({
    required int id,
    Object? label = ignore,
    Object? details = ignore,
    Object? important = ignore,
    Object? completed = ignore,
    Object? date = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (label != ignore) 1: label as String?,
          if (details != ignore) 2: details as String?,
          if (important != ignore) 3: important as bool?,
          if (completed != ignore) 4: completed as bool?,
          if (date != ignore) 5: date as DateTime?,
        }) >
        0;
  }
}

sealed class _TodoUpdateAll {
  int call({
    required List<int> id,
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  });
}

class _TodoUpdateAllImpl implements _TodoUpdateAll {
  const _TodoUpdateAllImpl(this.collection);

  final IsarCollection<int, Todo> collection;

  @override
  int call({
    required List<int> id,
    Object? label = ignore,
    Object? details = ignore,
    Object? important = ignore,
    Object? completed = ignore,
    Object? date = ignore,
  }) {
    return collection.updateProperties(id, {
      if (label != ignore) 1: label as String?,
      if (details != ignore) 2: details as String?,
      if (important != ignore) 3: important as bool?,
      if (completed != ignore) 4: completed as bool?,
      if (date != ignore) 5: date as DateTime?,
    });
  }
}

extension TodoUpdate on IsarCollection<int, Todo> {
  _TodoUpdate get update => _TodoUpdateImpl(this);

  _TodoUpdateAll get updateAll => _TodoUpdateAllImpl(this);
}

sealed class _TodoQueryUpdate {
  int call({
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  });
}

class _TodoQueryUpdateImpl implements _TodoQueryUpdate {
  const _TodoQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Todo> query;
  final int? limit;

  @override
  int call({
    Object? label = ignore,
    Object? details = ignore,
    Object? important = ignore,
    Object? completed = ignore,
    Object? date = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (label != ignore) 1: label as String?,
      if (details != ignore) 2: details as String?,
      if (important != ignore) 3: important as bool?,
      if (completed != ignore) 4: completed as bool?,
      if (date != ignore) 5: date as DateTime?,
    });
  }
}

extension TodoQueryUpdate on IsarQuery<Todo> {
  _TodoQueryUpdate get updateFirst => _TodoQueryUpdateImpl(this, limit: 1);

  _TodoQueryUpdate get updateAll => _TodoQueryUpdateImpl(this);
}

class _TodoQueryBuilderUpdateImpl implements _TodoQueryUpdate {
  const _TodoQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Todo, Todo, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? label = ignore,
    Object? details = ignore,
    Object? important = ignore,
    Object? completed = ignore,
    Object? date = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (label != ignore) 1: label as String?,
        if (details != ignore) 2: details as String?,
        if (important != ignore) 3: important as bool?,
        if (completed != ignore) 4: completed as bool?,
        if (date != ignore) 5: date as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension TodoQueryBuilderUpdate on QueryBuilder<Todo, Todo, QOperations> {
  _TodoQueryUpdate get updateFirst =>
      _TodoQueryBuilderUpdateImpl(this, limit: 1);

  _TodoQueryUpdate get updateAll => _TodoQueryBuilderUpdateImpl(this);
}

extension TodoQueryFilter on QueryBuilder<Todo, Todo, QFilterCondition> {
  QueryBuilder<Todo, Todo, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> detailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> importantEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> completedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension TodoQueryObject on QueryBuilder<Todo, Todo, QFilterCondition> {}

extension TodoQuerySortBy on QueryBuilder<Todo, Todo, QSortBy> {
  QueryBuilder<Todo, Todo, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByLabelDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByDetailsDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }
}

extension TodoQuerySortThenBy on QueryBuilder<Todo, Todo, QSortThenBy> {
  QueryBuilder<Todo, Todo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByLabelDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByDetailsDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<Todo, Todo, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }
}

extension TodoQueryWhereDistinct on QueryBuilder<Todo, Todo, QDistinct> {
  QueryBuilder<Todo, Todo, QAfterDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterDistinct> distinctByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Todo, Todo, QAfterDistinct> distinctByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<Todo, Todo, QAfterDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<Todo, Todo, QAfterDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }
}

extension TodoQueryProperty1 on QueryBuilder<Todo, Todo, QProperty> {
  QueryBuilder<Todo, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Todo, String, QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Todo, String, QAfterProperty> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Todo, bool, QAfterProperty> importantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Todo, bool, QAfterProperty> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Todo, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension TodoQueryProperty2<R> on QueryBuilder<Todo, R, QAfterProperty> {
  QueryBuilder<Todo, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Todo, (R, String), QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Todo, (R, String), QAfterProperty> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Todo, (R, bool), QAfterProperty> importantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Todo, (R, bool), QAfterProperty> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Todo, (R, DateTime), QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension TodoQueryProperty3<R1, R2>
    on QueryBuilder<Todo, (R1, R2), QAfterProperty> {
  QueryBuilder<Todo, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Todo, (R1, R2, String), QOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Todo, (R1, R2, String), QOperations> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Todo, (R1, R2, bool), QOperations> importantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Todo, (R1, R2, bool), QOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Todo, (R1, R2, DateTime), QOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}
