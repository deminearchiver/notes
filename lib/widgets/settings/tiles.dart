import 'package:flutter/foundation.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/onboarding/onboarding.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:provider/provider.dart';

class LanguageSettingsTile extends StatelessWidget {
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const Icon(Symbols.translate_rounded),
      title: Text("Language"),
    );
  }
}

class DynamicColorSettingsTile extends StatelessWidget {
  const DynamicColorSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Settings.watch(context);
    return GestureDetector(
      onLongPress: () => settings.useDynamicColor = null,
      child: SwitchListTile(
        onChanged: (value) => settings.useDynamicColor = value,
        value: settings.useDynamicColor,
        secondary: const Icon(Symbols.gradient_rounded),
        title: Text("Use Dynamic Color"),
        subtitle: Text("Use Material You Dynamic color"),
      ),
    );
  }
}

class BrightnessSettingsTile extends StatelessWidget {
  const BrightnessSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Settings.watch(context);
    return ListTile(
      onTap: () => showBrightnessPicker(context: context),
      leading: const Icon(Symbols.brightness_6_rounded),
      title: const Text("Theme color mode"),
      subtitle: const Text("Use system brightness"),
      trailing: ResetIconButton(
        onPressed: !settings.useSystemBrightness
            ? () {
                settings.useSystemBrightness = true;
                settings.brightness =
                    PlatformDispatcher.instance.platformBrightness;
              }
            : null,
      ),
    );
  }
}

class ExchangeKindsSettingsTile extends StatelessWidget {
  const ExchangeKindsSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Settings.watch(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Symbols.export_notes_rounded),
          title: const Text("Exchange formats"),
          subtitle:
              const Text("Choose how you are planning to exchange your notes"),
          trailing: ResetIconButton(
            onPressed: !setEquals(
              settings.exchangeKinds,
              settings.exchangeKindsStore.defaultStore.value,
            )
                ? () => settings.exchangeKinds = null
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<ExchangeKind>(
            onSelectionChanged: (values) => settings.exchangeKinds = values,
            selected: settings.exchangeKinds,
            multiSelectionEnabled: true,
            emptySelectionAllowed: false,
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ExchangeKind.plainText,
                icon: Icon(Symbols.text_fields_alt_rounded),
                label: Text("Plain text"),
              ),
              ButtonSegment(
                value: ExchangeKind.markdown,
                icon: Icon(Symbols.markdown_rounded),
                label: Text("Markdown"),
              ),
              ButtonSegment(
                value: ExchangeKind.json,
                icon: Icon(Symbols.data_object_rounded),
                label: Text("JSON"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditorKindSettingsTile extends StatelessWidget {
  const EditorKindSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Settings.watch(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Symbols.text_fields_alt_rounded),
          title: const Text("Editor"),
          subtitle: const Text("Choose your preferred rich text editor"),
          trailing: ResetIconButton(
            onPressed: settings.editorKind !=
                    settings.editorKindStore.defaultStore.value
                ? () => settings.editorKind = null
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<EditorKind>(
            onSelectionChanged: (values) => settings.editorKind = values.first,
            selected: {settings.editorKind},
            segments: const [
              ButtonSegment(
                value: EditorKind.flutterQuill,
                label: Text("Flutter Quill"),
              ),
              ButtonSegment(
                value: EditorKind.fleather,
                label: Text("Fleather"),
              ),
              ButtonSegment(
                value: EditorKind.superEditor,
                label: Text("Super Editor"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
