import 'dart:async';

import 'package:fleather/fleather.dart';
import 'package:notes/database/database.dart';
import 'package:notes/services/notifications.dart';
import 'package:parchment/codecs.dart';
import 'package:parchment/parchment.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/settings/scaffold.dart';
import 'package:notes/views/settings/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart' show SliverPinnedHeader;
import 'package:notes/flutter.dart';

class SettingsViewDeveloperPage extends StatefulWidget {
  const SettingsViewDeveloperPage({super.key});

  @override
  State<SettingsViewDeveloperPage> createState() =>
      _SettingsViewDeveloperPageState();
}

class _SettingsViewDeveloperPageState extends State<SettingsViewDeveloperPage> {
  bool _createdDemos = false;

  Future<void> _clearDatabase(AppDatabase database) async {
    await database.delete(database.notes).go();
    await database.delete(database.todos).go();
    await NotificationService.cancelAll();
  }

  Future<void> _createDemoRecords(AppDatabase database) async {
    await _clearDatabase(database);

    ParchmentDocument documentFromOperations(Iterable<Operation> operations) {
      final delta = Delta();
      operations.forEach(delta.push);
      return ParchmentDocument.fromDelta(delta);
    }

    ParchmentDocument markdownDocument(String markdown) {
      if (markdown.trim().isEmpty) return ParchmentDocument();
      return parchmentMarkdown.decode(markdown);
    }

    final now = DateTime.now();
    final notesList = <NotesCompanion>[
      NotesCompanion.insert(
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
        contentText: markdownDocument("""
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
""").toPlainText(),
        createdAt: DateTime(2024, 1, 31, 13, 47),
        updatedAt: DateTime(2024, 1, 31, 13, 47),
        favorite: false,
      ),
      NotesCompanion.insert(
        title: "Фреймворки",
        content: markdownDocument("""
Фреймворки

1. [**Electron**](https://electronjs.org)
    * технология: [**Chromium**](https://www.chromium.org)
    * язык: JavaScript
2. [**Tauri**](https://beta.tauri.app)
    * технология: [**WebView2**](https://developer.microsoft.com/ru-ru/microsoft-edge/webview2)
    * языки: [**Rust**](https://rust-lang.org) / JavaScript
3. Flutter
    * язык: [**Dart**](https://dart.dev)
"""),
        contentText: markdownDocument("""
Фреймворки

1. [**Electron**](https://electronjs.org)
    * технология: [**Chromium**](https://www.chromium.org)
    * язык: JavaScript
2. [**Tauri**](https://beta.tauri.app)
    * технология: [**WebView2**](https://developer.microsoft.com/ru-ru/microsoft-edge/webview2)
    * языки: [**Rust**](https://rust-lang.org) / JavaScript
3. Flutter
    * язык: [**Dart**](https://dart.dev)
""").toPlainText(),
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now.subtract(const Duration(days: 25)),
        favorite: false,
      ),
      NotesCompanion.insert(
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
        contentText: documentFromOperations([
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
        ]).toPlainText(),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 2)),
        favorite: false,
      ),
      ...List.generate(5, (index) {
        final doc = markdownDocument("""
Демо-заметка

Итерация ${index + 1}-ая
""");
        return NotesCompanion.insert(
          title: "Заметка №${index + 1}",
          content: doc,
          contentText: doc.toPlainText(),
          createdAt: now.subtract(const Duration(days: 365)),
          updatedAt: now.subtract(const Duration(days: 200)),
          favorite: false,
        );
      }),
      NotesCompanion.insert(
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
        contentText: markdownDocument("""
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
""").toPlainText(),
        createdAt: now,
        updatedAt: now,
        favorite: false,
      ),
    ];

    await database.batch((b) {
      b.insertAll(database.notes, notesList);
    });

    final todosList = <TodosCompanion>[
      TodosCompanion.insert(
        label: "Рассказать о задачах",
        details: const .new(
          "Не забыть рассказать о задачах и напоминаниях во время презентации",
        ),
        important: const .new(true),
        date: now.add(const Duration(minutes: 10)),
      ),
      TodosCompanion.insert(
        label: "Демо-напоминание",
        details: const .new("Так выглядит напоминание о задаче"),
        completed: const .new(false),
        date: now.add(const Duration(seconds: 5)),
      ),
      TodosCompanion.insert(
        label: "Сделать уроки",
        details: const .new("Информатика и английский язык"),
        completed: const .new(false),
        date: now.add(const Duration(days: 1)),
      ),
    ];

    for (final todoCompanion in todosList) {
      final id = await database.into(database.todos).insert(todoCompanion);
      final todo = await (database.select(
        database.todos,
      )..where((t) => t.id.equals(id))).getSingle();
      await NotificationService.scheduleTodoNotification(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Settings.of(context);
    return SettingsScaffold.sliver(
      title: const Text("Для разработчиков"),
      slivers: [
        SliverPinnedHeader(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card.filled(
              color: theme.colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ListTile(
                onTap: () => settings.developerMode = !settings.developerMode,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Icon(
                  MaterialSymbols.code_rounded,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                title: Text(
                  "Режим разработчика",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                trailing: Switch(
                  onCheckedChanged: (value) => settings.developerMode = value,
                  checked: settings.developerMode,
                ),
              ),
            ),
          ),
        ),
        SliverClip(
          child: SliverList.list(
            children: [
              SettingsSectionHeader(
                "Демо-режим",
                enabled: settings.developerMode,
              ),
              SettingsListTile(
                enabled: settings.developerMode,
                leading: const Icon(MaterialSymbols.podium_rounded),
                title: const Text("Демо записи"),
                subtitle: const Text("Заметки и задачи для презентации"),
                trailing: FilledButton.tonal(
                  onPressed: settings.developerMode && !_createdDemos
                      ? () async {
                          final database = AppDatabase.of(
                            context,
                            listen: false,
                          );
                          unawaited(_createDemoRecords(database));
                          if (context.mounted) {
                            setState(() => _createdDemos = true);
                          }
                        }
                      : null,
                  clipBehavior: Clip.antiAlias,
                  child: Flex.horizontal(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: Durations.medium4,
                        curve: Curves.easeInOutCubicEmphasized,
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        child: _createdDemos
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(MaterialSymbols.check_rounded),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const Text("Создать"),
                    ],
                  ),
                ),
              ),
              SettingsListTile(
                enabled: settings.developerMode,
                leading: const Icon(MaterialSymbols.delete_forever_rounded),
                title: const Text("Очистить базу данных"),
                subtitle: const Text("Удалить все записи из базы данных"),
                trailing: OutlinedButton(
                  onPressed: settings.developerMode
                      ? () async {
                          final database = AppDatabase.of(
                            context,
                            listen: false,
                          );
                          await _clearDatabase(database);
                          if (context.mounted) {
                            setState(() => _createdDemos = false);
                          }
                        }
                      : null,
                  child: const Text("Очистить"),
                ),
              ),
              // SettingsListTile.toggle(
              //   onChanged: settings.developerMode ? (value) {} : null,
              //   value: false,
              //   leading: Icon(MaterialSymbols.update_rounded),
              //   title: Text("Авто-обновление"),
              //   subtitle: Text("Обновлять демо-записи при запуске"),
              // ),
              // SettingsSectionHeader("Отладка", enabled: settings.developerMode),
            ],
          ),
        ),
      ],
    );
  }
}
