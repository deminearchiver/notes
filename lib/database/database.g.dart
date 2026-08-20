// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Notes extends Table with TableInfo<Notes, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Notes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<ParchmentDocument, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (json_valid(content))',
  ).withConverter<ParchmentDocument>(Notes.$convertercontent);
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    contentText,
    createdAt,
    updatedAt,
    favorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    } else if (isInserting) {
      context.missing(_favoriteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: Notes.$convertercontent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        )!,
      ),
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
    );
  }

  @override
  Notes createAlias(String alias) {
    return Notes(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ParchmentDocument, String, Object?>
  $convertercontent = parchmentJsonConverter;
  @override
  bool get dontWriteConstraints => true;
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String title;
  final ParchmentDocument content;
  final String contentText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorite;
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.contentText,
    required this.createdAt,
    required this.updatedAt,
    required this.favorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['content'] = Variable<String>(Notes.$convertercontent.toSql(content));
    }
    map['content_text'] = Variable<String>(contentText);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      contentText: Value(contentText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      favorite: Value(favorite),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: Notes.$convertercontent.fromJson(
        serializer.fromJson<Object?>(json['content']),
      ),
      contentText: serializer.fromJson<String>(json['content_text']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<Object?>(
        Notes.$convertercontent.toJson(content),
      ),
      'content_text': serializer.toJson<String>(contentText),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    ParchmentDocument? content,
    String? contentText,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? favorite,
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    contentText: contentText ?? this.contentText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    favorite: favorite ?? this.favorite,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('contentText: $contentText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    contentText,
    createdAt,
    updatedAt,
    favorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.contentText == this.contentText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.favorite == this.favorite);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> title;
  final Value<ParchmentDocument> content;
  final Value<String> contentText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> favorite;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.contentText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required ParchmentDocument content,
    required String contentText,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool favorite,
  }) : title = Value(title),
       content = Value(content),
       contentText = Value(contentText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       favorite = Value(favorite);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? contentText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (contentText != null) 'content_text': contentText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (favorite != null) 'favorite': favorite,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<ParchmentDocument>? content,
    Value<String>? contentText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? favorite,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      contentText: contentText ?? this.contentText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        Notes.$convertercontent.toSql(content.value),
      );
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('contentText: $contentText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }
}

class NotesFts extends Table
    with TableInfo<NotesFts, NoteFts>, VirtualTableInfo<NotesFts, NoteFts> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  NotesFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [title, contentText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteFts> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  NoteFts map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteFts(
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
    );
  }

  @override
  NotesFts createAlias(String alias) {
    return NotesFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(title, content_text, tokenize = "unicode61 remove_diacritics 1 tokenchars \'-\'", content = \'notes\', content_rowid = \'id\')';
}

class NoteFts extends DataClass implements Insertable<NoteFts> {
  final String title;
  final String contentText;
  const NoteFts({required this.title, required this.contentText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['content_text'] = Variable<String>(contentText);
    return map;
  }

  NotesFtsCompanion toCompanion(bool nullToAbsent) {
    return NotesFtsCompanion(
      title: Value(title),
      contentText: Value(contentText),
    );
  }

  factory NoteFts.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteFts(
      title: serializer.fromJson<String>(json['title']),
      contentText: serializer.fromJson<String>(json['content_text']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'content_text': serializer.toJson<String>(contentText),
    };
  }

  NoteFts copyWith({String? title, String? contentText}) => NoteFts(
    title: title ?? this.title,
    contentText: contentText ?? this.contentText,
  );
  NoteFts copyWithCompanion(NotesFtsCompanion data) {
    return NoteFts(
      title: data.title.present ? data.title.value : this.title,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteFts(')
          ..write('title: $title, ')
          ..write('contentText: $contentText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, contentText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteFts &&
          other.title == this.title &&
          other.contentText == this.contentText);
}

class NotesFtsCompanion extends UpdateCompanion<NoteFts> {
  final Value<String> title;
  final Value<String> contentText;
  final Value<int> rowid;
  const NotesFtsCompanion({
    this.title = const Value.absent(),
    this.contentText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesFtsCompanion.insert({
    required String title,
    required String contentText,
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       contentText = Value(contentText);
  static Insertable<NoteFts> custom({
    Expression<String>? title,
    Expression<String>? contentText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (contentText != null) 'content_text': contentText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesFtsCompanion copyWith({
    Value<String>? title,
    Value<String>? contentText,
    Value<int>? rowid,
  }) {
    return NotesFtsCompanion(
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesFtsCompanion(')
          ..write('title: $title, ')
          ..write('contentText: $contentText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Todos extends Table with TableInfo<Todos, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Todos(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _importantMeta = const VerificationMeta(
    'important',
  );
  late final GeneratedColumn<bool> important = GeneratedColumn<bool>(
    'important',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT FALSE',
    defaultValue: const CustomExpression('FALSE'),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT FALSE',
    defaultValue: const CustomExpression('FALSE'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    details,
    important,
    completed,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('important')) {
      context.handle(
        _importantMeta,
        important.isAcceptableOrUnknown(data['important']!, _importantMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
      important: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}important'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  Todos createAlias(String alias) {
    return Todos(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String label;
  final String details;
  final bool important;
  final bool completed;
  final DateTime date;
  const Todo({
    required this.id,
    required this.label,
    required this.details,
    required this.important,
    required this.completed,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['details'] = Variable<String>(details);
    map['important'] = Variable<bool>(important);
    map['completed'] = Variable<bool>(completed);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      label: Value(label),
      details: Value(details),
      important: Value(important),
      completed: Value(completed),
      date: Value(date),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      details: serializer.fromJson<String>(json['details']),
      important: serializer.fromJson<bool>(json['important']),
      completed: serializer.fromJson<bool>(json['completed']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'details': serializer.toJson<String>(details),
      'important': serializer.toJson<bool>(important),
      'completed': serializer.toJson<bool>(completed),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Todo copyWith({
    int? id,
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  }) => Todo(
    id: id ?? this.id,
    label: label ?? this.label,
    details: details ?? this.details,
    important: important ?? this.important,
    completed: completed ?? this.completed,
    date: date ?? this.date,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      details: data.details.present ? data.details.value : this.details,
      important: data.important.present ? data.important.value : this.important,
      completed: data.completed.present ? data.completed.value : this.completed,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('details: $details, ')
          ..write('important: $important, ')
          ..write('completed: $completed, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, details, important, completed, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.label == this.label &&
          other.details == this.details &&
          other.important == this.important &&
          other.completed == this.completed &&
          other.date == this.date);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> details;
  final Value<bool> important;
  final Value<bool> completed;
  final Value<DateTime> date;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.details = const Value.absent(),
    this.important = const Value.absent(),
    this.completed = const Value.absent(),
    this.date = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.details = const Value.absent(),
    this.important = const Value.absent(),
    this.completed = const Value.absent(),
    required DateTime date,
  }) : label = Value(label),
       date = Value(date);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? details,
    Expression<bool>? important,
    Expression<bool>? completed,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (details != null) 'details': details,
      if (important != null) 'important': important,
      if (completed != null) 'completed': completed,
      if (date != null) 'date': date,
    });
  }

  TodosCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String>? details,
    Value<bool>? important,
    Value<bool>? completed,
    Value<DateTime>? date,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      details: details ?? this.details,
      important: important ?? this.important,
      completed: completed ?? this.completed,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (important.present) {
      map['important'] = Variable<bool>(important.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('details: $details, ')
          ..write('important: $important, ')
          ..write('completed: $completed, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class TodosFts extends Table
    with TableInfo<TodosFts, TodoFts>, VirtualTableInfo<TodosFts, TodoFts> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TodosFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [label, details];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoFts> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TodoFts map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoFts(
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
    );
  }

  @override
  TodosFts createAlias(String alias) {
    return TodosFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(label, details, tokenize = "unicode61 remove_diacritics 1 tokenchars \'-\'", content = \'todos\', content_rowid = \'id\')';
}

class TodoFts extends DataClass implements Insertable<TodoFts> {
  final String label;
  final String details;
  const TodoFts({required this.label, required this.details});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['label'] = Variable<String>(label);
    map['details'] = Variable<String>(details);
    return map;
  }

  TodosFtsCompanion toCompanion(bool nullToAbsent) {
    return TodosFtsCompanion(label: Value(label), details: Value(details));
  }

  factory TodoFts.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoFts(
      label: serializer.fromJson<String>(json['label']),
      details: serializer.fromJson<String>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'label': serializer.toJson<String>(label),
      'details': serializer.toJson<String>(details),
    };
  }

  TodoFts copyWith({String? label, String? details}) =>
      TodoFts(label: label ?? this.label, details: details ?? this.details);
  TodoFts copyWithCompanion(TodosFtsCompanion data) {
    return TodoFts(
      label: data.label.present ? data.label.value : this.label,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoFts(')
          ..write('label: $label, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(label, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoFts &&
          other.label == this.label &&
          other.details == this.details);
}

class TodosFtsCompanion extends UpdateCompanion<TodoFts> {
  final Value<String> label;
  final Value<String> details;
  final Value<int> rowid;
  const TodosFtsCompanion({
    this.label = const Value.absent(),
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosFtsCompanion.insert({
    required String label,
    required String details,
    this.rowid = const Value.absent(),
  }) : label = Value(label),
       details = Value(details);
  static Insertable<TodoFts> custom({
    Expression<String>? label,
    Expression<String>? details,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (label != null) 'label': label,
      if (details != null) 'details': details,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosFtsCompanion copyWith({
    Value<String>? label,
    Value<String>? details,
    Value<int>? rowid,
  }) {
    return TodosFtsCompanion(
      label: label ?? this.label,
      details: details ?? this.details,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosFtsCompanion(')
          ..write('label: $label, ')
          ..write('details: $details, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Notes notes = Notes(this);
  late final NotesFts notesFts = NotesFts(this);
  late final Trigger notesInsert = Trigger(
    'CREATE TRIGGER notes_insert AFTER INSERT ON notes BEGIN INSERT INTO notes_fts ("rowid", title, content_text) VALUES (new.id, new.title, new.content_text);END',
    'notes_insert',
  );
  late final Trigger notesUpdate = Trigger(
    'CREATE TRIGGER notes_update AFTER UPDATE ON notes BEGIN DELETE FROM notes_fts WHERE "rowid" = old.id;INSERT INTO notes_fts ("rowid", title, content_text) VALUES (new.id, new.title, new.content_text);END',
    'notes_update',
  );
  late final Trigger notesDelete = Trigger(
    'CREATE TRIGGER notes_delete AFTER DELETE ON notes BEGIN DELETE FROM notes_fts WHERE "rowid" = old.id;END',
    'notes_delete',
  );
  late final Todos todos = Todos(this);
  late final TodosFts todosFts = TodosFts(this);
  late final Trigger todosInsert = Trigger(
    'CREATE TRIGGER todos_insert AFTER INSERT ON todos BEGIN INSERT INTO todos_fts ("rowid", label, details) VALUES (new.id, new.label, new.details);END',
    'todos_insert',
  );
  late final Trigger todosUpdate = Trigger(
    'CREATE TRIGGER todos_update AFTER UPDATE ON todos BEGIN DELETE FROM todos_fts WHERE "rowid" = old.id;INSERT INTO todos_fts ("rowid", label, details) VALUES (new.id, new.label, new.details);END',
    'todos_update',
  );
  late final Trigger todosDelete = Trigger(
    'CREATE TRIGGER todos_delete AFTER DELETE ON todos BEGIN DELETE FROM todos_fts WHERE "rowid" = old.id;END',
    'todos_delete',
  );
  Selectable<Note> allNotes() {
    return customSelect(
      'SELECT * FROM notes',
      variables: [],
      readsFrom: {notes},
    ).asyncMap(notes.mapFromRow);
  }

  Selectable<Todo> allTodos() {
    return customSelect(
      'SELECT * FROM todos',
      variables: [],
      readsFrom: {todos},
    ).asyncMap(todos.mapFromRow);
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    notes,
    notesFts,
    notesInsert,
    notesUpdate,
    notesDelete,
    todos,
    todosFts,
    todosInsert,
    todosUpdate,
    todosDelete,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('notes_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('notes_fts', kind: UpdateKind.delete),
        TableUpdate('notes_fts', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes_fts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'todos',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('todos_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'todos',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('todos_fts', kind: UpdateKind.delete),
        TableUpdate('todos_fts', kind: UpdateKind.insert),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'todos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('todos_fts', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $NotesCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required String title,
      required ParchmentDocument content,
      required String contentText,
      required DateTime createdAt,
      required DateTime updatedAt,
      required bool favorite,
    });
typedef $NotesUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<ParchmentDocument> content,
      Value<String> contentText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> favorite,
    });

class $NotesFilterComposer extends Composer<_$AppDatabase, Notes> {
  $NotesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ParchmentDocument, ParchmentDocument, String>
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $NotesOrderingComposer extends Composer<_$AppDatabase, Notes> {
  $NotesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $NotesAnnotationComposer extends Composer<_$AppDatabase, Notes> {
  $NotesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ParchmentDocument, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);
}

class $NotesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Notes,
          Note,
          $NotesFilterComposer,
          $NotesOrderingComposer,
          $NotesAnnotationComposer,
          $NotesCreateCompanionBuilder,
          $NotesUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, Notes, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $NotesTableManager(_$AppDatabase db, Notes table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $NotesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $NotesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $NotesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<ParchmentDocument> content = const Value.absent(),
                Value<String> contentText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                content: content,
                contentText: contentText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                favorite: favorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required ParchmentDocument content,
                required String contentText,
                required DateTime createdAt,
                required DateTime updatedAt,
                required bool favorite,
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                content: content,
                contentText: contentText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                favorite: favorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $NotesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Notes,
      Note,
      $NotesFilterComposer,
      $NotesOrderingComposer,
      $NotesAnnotationComposer,
      $NotesCreateCompanionBuilder,
      $NotesUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, Notes, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $NotesFtsCreateCompanionBuilder =
    NotesFtsCompanion Function({
      required String title,
      required String contentText,
      Value<int> rowid,
    });
typedef $NotesFtsUpdateCompanionBuilder =
    NotesFtsCompanion Function({
      Value<String> title,
      Value<String> contentText,
      Value<int> rowid,
    });

class $NotesFtsFilterComposer extends Composer<_$AppDatabase, NotesFts> {
  $NotesFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnFilters(column),
  );
}

class $NotesFtsOrderingComposer extends Composer<_$AppDatabase, NotesFts> {
  $NotesFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $NotesFtsAnnotationComposer extends Composer<_$AppDatabase, NotesFts> {
  $NotesFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => column,
  );
}

class $NotesFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          NotesFts,
          NoteFts,
          $NotesFtsFilterComposer,
          $NotesFtsOrderingComposer,
          $NotesFtsAnnotationComposer,
          $NotesFtsCreateCompanionBuilder,
          $NotesFtsUpdateCompanionBuilder,
          (NoteFts, BaseReferences<_$AppDatabase, NotesFts, NoteFts>),
          NoteFts,
          PrefetchHooks Function()
        > {
  $NotesFtsTableManager(_$AppDatabase db, NotesFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $NotesFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $NotesFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $NotesFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> title = const Value.absent(),
                Value<String> contentText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesFtsCompanion(
                title: title,
                contentText: contentText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String title,
                required String contentText,
                Value<int> rowid = const Value.absent(),
              }) => NotesFtsCompanion.insert(
                title: title,
                contentText: contentText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $NotesFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      NotesFts,
      NoteFts,
      $NotesFtsFilterComposer,
      $NotesFtsOrderingComposer,
      $NotesFtsAnnotationComposer,
      $NotesFtsCreateCompanionBuilder,
      $NotesFtsUpdateCompanionBuilder,
      (NoteFts, BaseReferences<_$AppDatabase, NotesFts, NoteFts>),
      NoteFts,
      PrefetchHooks Function()
    >;
typedef $TodosCreateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      required String label,
      Value<String> details,
      Value<bool> important,
      Value<bool> completed,
      required DateTime date,
    });
typedef $TodosUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<String> details,
      Value<bool> important,
      Value<bool> completed,
      Value<DateTime> date,
    });

class $TodosFilterComposer extends Composer<_$AppDatabase, Todos> {
  $TodosFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get important => $composableBuilder(
    column: $table.important,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $TodosOrderingComposer extends Composer<_$AppDatabase, Todos> {
  $TodosOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get important => $composableBuilder(
    column: $table.important,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TodosAnnotationComposer extends Composer<_$AppDatabase, Todos> {
  $TodosAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<bool> get important =>
      $composableBuilder(column: $table.important, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $TodosTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Todos,
          Todo,
          $TodosFilterComposer,
          $TodosOrderingComposer,
          $TodosAnnotationComposer,
          $TodosCreateCompanionBuilder,
          $TodosUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, Todos, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $TodosTableManager(_$AppDatabase db, Todos table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TodosFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TodosOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TodosAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<bool> important = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                label: label,
                details: details,
                important: important,
                completed: completed,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                Value<String> details = const Value.absent(),
                Value<bool> important = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                required DateTime date,
              }) => TodosCompanion.insert(
                id: id,
                label: label,
                details: details,
                important: important,
                completed: completed,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TodosProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Todos,
      Todo,
      $TodosFilterComposer,
      $TodosOrderingComposer,
      $TodosAnnotationComposer,
      $TodosCreateCompanionBuilder,
      $TodosUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, Todos, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $TodosFtsCreateCompanionBuilder =
    TodosFtsCompanion Function({
      required String label,
      required String details,
      Value<int> rowid,
    });
typedef $TodosFtsUpdateCompanionBuilder =
    TodosFtsCompanion Function({
      Value<String> label,
      Value<String> details,
      Value<int> rowid,
    });

class $TodosFtsFilterComposer extends Composer<_$AppDatabase, TodosFts> {
  $TodosFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $TodosFtsOrderingComposer extends Composer<_$AppDatabase, TodosFts> {
  $TodosFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TodosFtsAnnotationComposer extends Composer<_$AppDatabase, TodosFts> {
  $TodosFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $TodosFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          TodosFts,
          TodoFts,
          $TodosFtsFilterComposer,
          $TodosFtsOrderingComposer,
          $TodosFtsAnnotationComposer,
          $TodosFtsCreateCompanionBuilder,
          $TodosFtsUpdateCompanionBuilder,
          (TodoFts, BaseReferences<_$AppDatabase, TodosFts, TodoFts>),
          TodoFts,
          PrefetchHooks Function()
        > {
  $TodosFtsTableManager(_$AppDatabase db, TodosFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TodosFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TodosFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TodosFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> label = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosFtsCompanion(
                label: label,
                details: details,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String label,
                required String details,
                Value<int> rowid = const Value.absent(),
              }) => TodosFtsCompanion.insert(
                label: label,
                details: details,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TodosFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      TodosFts,
      TodoFts,
      $TodosFtsFilterComposer,
      $TodosFtsOrderingComposer,
      $TodosFtsAnnotationComposer,
      $TodosFtsCreateCompanionBuilder,
      $TodosFtsUpdateCompanionBuilder,
      (TodoFts, BaseReferences<_$AppDatabase, TodosFts, TodoFts>),
      TodoFts,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $NotesTableManager get notes => $NotesTableManager(_db, _db.notes);
  $NotesFtsTableManager get notesFts =>
      $NotesFtsTableManager(_db, _db.notesFts);
  $TodosTableManager get todos => $TodosTableManager(_db, _db.todos);
  $TodosFtsTableManager get todosFts =>
      $TodosFtsTableManager(_db, _db.todosFts);
}
