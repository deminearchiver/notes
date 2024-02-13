import 'package:flutter/widgets.dart';
import 'package:true_material/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.text, {
    super.key,
    this.icon,
    this.enabled = true,
    this.padding,
  });

  final Widget? icon;
  final String text;

  final bool enabled;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              if (icon != null)
                IconTheme.merge(
                  data: IconThemeData(color: theme.colorScheme.primary),
                  child: icon!,
                ),
              if (icon != null) const SizedBox(width: 8),
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color:
                      enabled ? theme.colorScheme.primary : theme.disabledColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
