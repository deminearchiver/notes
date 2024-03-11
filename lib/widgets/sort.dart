import 'package:collection/collection.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/utils/extensions.dart';
import 'package:material/material.dart';
import 'package:isar/isar.dart';
import 'package:material_symbols_icons/symbols.dart';

class SortDetails<T> {
  const SortDetails({
    required this.sort,
    required this.order,
  });

  final T sort;
  final Sort order;
}

class SortRow<T> extends StatelessWidget {
  const SortRow({
    super.key,
    required this.onSortChanged,
    required this.selected,
    required this.order,
    required this.types,
  });

  final ValueChanged<SortDetails<T>> onSortChanged;
  final T selected;
  final Sort order;
  final List<SortType<T>> types;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => onSortChanged(
            SortDetails(
              sort: selected,
              order: order.reverse(),
            ),
          ),
          icon: AnimatedRotation(
            turns: order == Sort.asc ? 0 : 0.5,
            duration: Durations.long2,
            curve: Easing.emphasized,
            child: const Icon(Symbols.north_rounded),
          ),
          tooltip: order == Sort.asc
              ? localizations.sort_ascending
              : localizations.sort_descending,
        ),
        VerticalDivider(
          color: theme.colorScheme.onSurface,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...types.mapIndexed(
                  (index, type) => Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? 4 : 0,
                      right: index + 1 < types.length ? 4 : 0,
                    ),
                    child: ChoiceChip(
                      onSelected: (value) => onSortChanged(
                        SortDetails(
                          sort: type.value,
                          order: order,
                        ),
                      ),
                      selected: selected == type.value,
                      showCheckmark: false,
                      avatar: type.icon != null
                          ? IconTheme.merge(
                              data: IconThemeData(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              child: type.icon!)
                          : null,
                      label: Text(type.label),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SortType<T> {
  const SortType({
    required this.value,
    this.icon,
    required this.label,
  });

  final T value;
  final Widget? icon;
  final String label;
}
