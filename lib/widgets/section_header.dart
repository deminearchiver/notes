import 'package:flutter/widgets.dart';
import 'package:material/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.text, {
    super.key,
    this.icon,
    this.enabled = true,
    this.padding,
    this.showDivider = false,
  });

  final Widget? icon;
  final String text;

  final bool enabled;
  final EdgeInsets? padding;

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDivider) const Divider(),
        Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              if (icon != null)
                IconTheme.merge(
                  data: IconThemeData(color: theme.colorScheme.secondary),
                  child: icon!,
                ),
              if (icon != null) const SizedBox(width: 8),
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: enabled
                      ? theme.colorScheme.secondary
                      : theme.disabledColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
