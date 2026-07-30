import 'package:collection/collection.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/utils/extensions.dart';
import 'package:notes/flutter.dart';
import 'package:isar_plus/isar_plus.dart';

class SortDetails<T> {
  const SortDetails({required this.sort, required this.order});

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
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final ValueChanged<SortDetails<T>> onSortChanged;
  final T selected;
  final Sort order;
  final List<SortType<T>> types;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: padding.copyWith(right: 0),
      child: Flex.horizontal(
        children: [
          IconButton(
            onPressed: () => onSortChanged(
              SortDetails(sort: selected, order: order.reverse()),
            ),
            icon: AnimatedRotation(
              turns: order == Sort.asc ? 0 : 0.5,
              duration: Durations.long2,
              curve: Curves.easeInOutCubicEmphasized,
              child: const Icon(MaterialSymbols.north_rounded),
            ),
            tooltip: order == Sort.asc
                ? localizations.sort_ascending
                : localizations.sort_descending,
          ),
          VerticalDivider(color: theme.colorScheme.onSurface),
          Flexible.tight(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: padding.right),
              child: Flex.horizontal(
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
                          SortDetails(sort: type.value, order: order),
                        ),
                        selected: selected == type.value,
                        showCheckmark: false,
                        avatar: type.icon != null
                            ? IconTheme.mergeWithData(
                                data: IconThemeDataPartial.from(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                                child: type.icon!,
                              )
                            : null,
                        label: Text(type.label),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SortType<T> {
  const SortType({required this.value, this.icon, required this.label});

  final T value;
  final Widget? icon;
  final String label;
}
