import 'package:fleather/fleather.dart';
import 'package:isar/isar.dart';
import 'package:notes/database/note.dart';
import 'package:notes/database/todo.dart';
import 'package:notes/services/notifications.dart';
import 'package:parchment/codecs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:parchment_delta/parchment_delta.dart';

enum NotesSortBy {
  title,
  createdAt,
  updatedAt,
}

enum TodosSortBy {
  label,
  date,
}

abstract class Database {
  static late final Isar isar;

  static Future<void> createDemoRecords() async {
    await clear();

    ParchmentDocument documentFromOperations(Iterable<Operation> operations) {
      final delta = Delta();
      for (final operation in operations) {
        delta.push(operation);
      }
      return ParchmentDocument.fromDelta(delta);
    }

    ParchmentDocument markdownDocument(String markdown) {
      if (markdown.trim().isEmpty) return ParchmentDocument();
      return parchmentMarkdown.decode(markdown);
    }

    final now = DateTime.now();
    final notes = <Note>[
      createNote(
        title: "Добро пожаловать!",
        content: markdownDocument("""
В приложении "Заметки" вы можете управлять вашими заметками и задачами.

### Возможности
Сдесь перечислены некоторые функции приложения.
* заметки:
    * создавать, сохранять, редатировать, удалять
    * производить поиск, сортировать
    * форматировать текст содержимого
* задачи:
    * создавать, сохранять, редактировать, удалять
    * производить поиск, сортировать
    * помечать как важные
    * устанавливать напоминания
* обзор
    * просматривать недавно открытые заметки и задачи
    * производить поиск
* настройки
    * менять язык и тему приложения
    * производить сброс настроек
"""),
        createdAt: DateTime(2024, 1, 31, 13, 47),
        updatedAt: DateTime(2024, 1, 31, 13, 47),
      ),
      createNote(
        title: "Фреймворки",
        content: markdownDocument(
          """
Фреймворки

1. [**Electron**](https://electronjs.org)
    * технология: [**Chromium**](https://www.chromium.org)
    * язык: JavaScript
2. [**Tauri**](https://beta.tauri.app)
    * технология: [**WebView2**](https://developer.microsoft.com/ru-ru/microsoft-edge/webview2)
    * языки: [**Rust**](https://rust-lang.org) / JavaScript
3. Flutter
    * язык: [**Dart**](https://dart.dev)
""",
        ),
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now.subtract(const Duration(days: 25)),
      ),
      createNote(
        title: "Список покупок",
        content: documentFromOperations([
          Operation.insert("Продукты:\n"),
          Operation.insert("Хлеб ржаной, 1 буханка"),
          Operation.insert(
            "\n",
            ParchmentStyle().put(ParchmentAttribute.cl).toJson(),
          ),
          Operation.insert("Бутылка воды, 5 л"),
          Operation.insert(
            "\n",
            ParchmentStyle().putAll([
              ParchmentAttribute.cl,
              ParchmentAttribute.checked,
            ]).toJson(),
          ),
          Operation.insert("Молоко, 0,5 л"),
          Operation.insert(
            "\n",
            ParchmentStyle().put(ParchmentAttribute.cl).toJson(),
          ),
          Operation.insert("Сметана"),
          Operation.insert(
            "\n",
            ParchmentStyle().put(ParchmentAttribute.cl).toJson(),
          ),
          Operation.insert("Конфеты, 500 г"),
          Operation.insert(
            "\n",
            ParchmentStyle().putAll([
              ParchmentAttribute.cl,
              ParchmentAttribute.checked,
            ]).toJson(),
          ),
        ]),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ...List.generate(
        5,
        (index) => createNote(
          title: "Заметка №${index + 1}",
          content: markdownDocument("""
Демо-заметка

Итерация ${index + 1}-ая
"""),
          createdAt: now.subtract(const Duration(days: 365)),
          updatedAt: now.subtract(const Duration(days: 200)),
        ),
      ),
      createNote(
        title: "Форматирование",
        content: markdownDocument("""
Текст в заметках может быть отформатирован. Ниже представлено большинство возможностей форматирования.

Обычный текст
Жирный текст
Текст курсивом
Подчёркнутый текст

# Заголовок 1
## Заголовок 2
### Заголовок 3
#### Заголовок 4
##### Заголовок 5
###### Заголовок 6

`строчный код`

```
Блок кода
Поддерживает нумерацию строк
```

Неупорядоченный список:
* Первый
* Второй
* Третий

Упорядоченный список:
1. Первый
2. Второй
3. Третий
"""),
        createdAt: now,
        updatedAt: now,
      )
    ];

    await addNotes(notes);

    final todos = <Todo>[
      createTodo(
        label: "Рассказать о задачах",
        details:
            "Не забыть рассказать о задачах и напоминаниях во время презентации",
        important: true,
        date: now.add(const Duration(minutes: 10)),
      ),
      createTodo(
        label: "Демо-напоминание",
        details: "Так выглядит напоминание о задаче",
        completed: false,
        date: now.add(const Duration(seconds: 5)),
      ),
      createTodo(
        label: "Сделать уроки",
        details: "Информатика и английский язык",
        completed: false,
        date: now.add(const Duration(days: 1)),
      )
    ];
    await addTodos(todos);
  }

  static Future<void> init() async {
    final supportDir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      schemas: [
        NoteSchema,
        TodoSchema,
      ],
      directory: supportDir.path,
    );
  }

  static Future<void> clear() async {
    await isar.writeAsync((isar) => isar.clear());
    await NotificationService.cancelAll();
  }

  static int get notesCount => isar.notes.count();
  static int get todosCount => isar.todos.count();

  static Future<List<Note>> getAllNotes({
    NotesSortBy sort = NotesSortBy.updatedAt,
    Sort order = Sort.desc,
  }) async {
    final where = isar.notes.where();
    final notes = switch (sort) {
      NotesSortBy.title =>
        order == Sort.asc ? where.sortByTitle() : where.sortByTitleDesc(),
      NotesSortBy.createdAt => order == Sort.asc
          ? where.sortByCreatedAt()
          : where.sortByCreatedAtDesc(),
      NotesSortBy.updatedAt => order == Sort.asc
          ? where.sortByUpdatedAt()
          : where.sortByUpdatedAtDesc(),
    };
    return notes.findAll();
  }

  static Stream<List<Note>> watchAllNotes({
    NotesSortBy sort = NotesSortBy.updatedAt,
    Sort order = Sort.desc,
  }) {
    final where = isar.notes.where();
    final notes = switch (sort) {
      NotesSortBy.title =>
        order == Sort.asc ? where.sortByTitle() : where.sortByTitleDesc(),
      NotesSortBy.createdAt => order == Sort.asc
          ? where.sortByCreatedAt()
          : where.sortByCreatedAtDesc(),
      NotesSortBy.updatedAt => order == Sort.asc
          ? where.sortByUpdatedAt()
          : where.sortByUpdatedAtDesc(),
    };
    return notes.watch(fireImmediately: true);
  }

  static Stream<List<Note>> watchSearchNotes(
    String query, {
    NotesSortBy sort = NotesSortBy.updatedAt,
    Sort order = Sort.desc,
  }) {
    if (query.isEmpty) return watchAllNotes(sort: sort, order: order);

    final filter = isar.notes
        .where()
        .titleContains(query, caseSensitive: false)
        .or()
        .contentTextContains(
          query,
          caseSensitive: false,
        );
    final notes = switch (sort) {
      NotesSortBy.title =>
        order == Sort.asc ? filter.sortByTitle() : filter.sortByTitleDesc(),
      NotesSortBy.createdAt => order == Sort.asc
          ? filter.sortByCreatedAt()
          : filter.sortByCreatedAtDesc(),
      NotesSortBy.updatedAt => order == Sort.asc
          ? filter.sortByUpdatedAt()
          : filter.sortByUpdatedAtDesc(),
    };
    return notes.watch(fireImmediately: true);
  }

  static Future<void> addNote(Note note) async {
    await isar.writeAsync((isar) => isar.notes.put(note));
  }

  static Future<void> addNotes(List<Note> notes) async {
    await isar.writeAsync((isar) => isar.notes.putAll(notes));
  }

  static Future<void> deleteNote(int id) async {
    await isar.writeAsync((isar) => isar.notes.delete(id));
  }

  static Future<List<Todo>> getAllTodos({
    TodosSortBy sort = TodosSortBy.date,
    Sort order = Sort.asc,
  }) async {
    final where = isar.todos.where();
    final todos = switch (sort) {
      TodosSortBy.label =>
        order == Sort.asc ? where.sortByLabel() : where.sortByLabelDesc(),
      TodosSortBy.date =>
        order == Sort.asc ? where.sortByDate() : where.sortByDateDesc(),
    };
    return todos.findAll();
  }

  static Stream<List<Todo>> watchAllTodos({
    TodosSortBy sort = TodosSortBy.date,
    Sort order = Sort.asc,
  }) {
    final where = isar.todos.where();
    final todos = switch (sort) {
      TodosSortBy.label =>
        order == Sort.asc ? where.sortByLabel() : where.sortByLabelDesc(),
      TodosSortBy.date =>
        order == Sort.asc ? where.sortByDate() : where.sortByDateDesc(),
    };
    return todos.watch(fireImmediately: true);
  }

  static Stream<List<Todo>> watchSearchTodos(
    String query, {
    TodosSortBy sort = TodosSortBy.date,
    Sort order = Sort.asc,
  }) {
    if (query.isEmpty) return watchAllTodos(sort: sort, order: order);

    final filter = isar.todos
        .where()
        .labelContains(query, caseSensitive: false)
        .or()
        .detailsContains(query, caseSensitive: false);

    final todos = switch (sort) {
      TodosSortBy.label =>
        order == Sort.asc ? filter.sortByLabel() : filter.sortByLabelDesc(),
      TodosSortBy.date =>
        order == Sort.asc ? filter.sortByDate() : filter.sortByDateDesc(),
    };
    return todos.watch(fireImmediately: true);
  }

  static Future<Todo?> getTodo(int id) async {
    return isar.todos.get(id);
  }

  static Future<void> addTodo(Todo todo) async {
    await isar.writeAsync((isar) => isar.todos.put(todo));
    // TODO: move this logic somewhere else

    await NotificationService.cancel(todo.id);
    if (!todo.completed) {
      await NotificationService.scheduleTodoNotification(todo);
    }
  }

  // static Future<void> updateTodo(Todo todo) async {
  //   final exists = await getTodo(todo.id);
  //   if (exists != null) return;
  //   await isar.writeTxn(() => isar.todos.put(todo));

  //   await NotificationService.cancel(todo.id);
  //   await NotificationService.scheduleTodoNotification(todo);
  // }

  static Future<void> addTodos(List<Todo> todos) async {
    await isar.writeAsync((isar) => isar.todos.putAll(todos));
    for (final todo in todos) {
      await NotificationService.scheduleTodoNotification(todo);
    }
  }

  static Future<void> deleteTodo(int id) async {
    final todo = await getTodo(id);
    if (todo == null) return;

    await NotificationService.cancel(todo.id);

    await isar.writeAsync((isar) => isar.todos.delete(id));
  }

  static Note createNote({
    int? id,
    required String title,
    ParchmentDocument? content,
    bool favorite = false,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    if (updatedAt != null) {
      assert(updatedAt.compareTo(createdAt ?? DateTime.now()) >= 0);
    }
    return Note()
      ..id = id ?? isar.notes.autoIncrement()
      ..title = title
      ..content = content ?? ParchmentDocument()
      ..favorite = favorite
      ..createdAt = createdAt ?? DateTime.now()
      ..updatedAt = updatedAt ?? DateTime.now();
  }

  static Todo createTodo({
    int? id,
    required String label,
    required DateTime date,
    String? details,
    bool important = false,
    bool completed = false,
  }) {
    return Todo()
      ..id = id ?? isar.todos.autoIncrement()
      ..label = label
      ..details = details ?? ""
      ..date = date
      ..important = important
      ..completed = completed;
  }
}
