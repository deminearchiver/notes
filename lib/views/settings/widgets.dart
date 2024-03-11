import 'package:flutter/widgets.dart';
import 'package:material/material.dart';

enum _SettingsListTileVariant {
  regular,
  topLevel,
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : _variant = _SettingsListTileVariant.regular;
  const SettingsListTile.topLevel({
    super.key,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : _variant = _SettingsListTileVariant.topLevel;

  factory SettingsListTile.toggle({
    required ValueChanged<bool>? onChanged,
    required bool value,
    VoidCallback? onLongPress,
    Widget? leading,
    required Widget title,
    Widget? subtitle,
  }) = _ToggleSettingsListTile;

  final _SettingsListTileVariant _variant;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool enabled;

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final leadingChild = leading != null
        ? IconTheme.merge(
            data: IconThemeData(
              color:
                  enabled ? theme.colorScheme.onSurface : theme.disabledColor,
            ),
            child: leading!,
          )
        : null;

    if (_variant == _SettingsListTileVariant.regular) {
      return ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        leading: leadingChild,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      );
    }

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: subtitle != null ? 8 : 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      leading: leadingChild,
      title: title,
      titleTextStyle: theme.textTheme.titleMedium,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

class _ToggleSettingsListTile extends SettingsListTile {
  _ToggleSettingsListTile({
    required ValueChanged<bool>? onChanged,
    required bool value,
    super.onLongPress,
    super.leading,
    required super.title,
    super.subtitle,
  }) : super(
          onTap: onChanged != null ? () => onChanged(!value) : null,
          trailing: Switch(
            onChanged: onChanged,
            value: value,
          ),
          enabled: onChanged != null,
        );
}

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader(
    this.text, {
    super.key,
    this.enabled = true,
  });

  final String text;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color:
                  enabled ? theme.colorScheme.secondary : theme.disabledColor,
            ),
          ),
        )
      ],
    );
  }
}
