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
  });

  final ValueChanged<SortDetails<T>> onSortChanged;
  final T selected;
  final Sort order;
  final List<SortType<T>> types;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    return Flex.horizontal(
      spacing: 12.0,
      children: [
        SizedTouchTarget(
          minimumSize: const .square(48.0),
          child: IconButton(
            style: LegacyThemeFactory.createIconButtonStyle(
              colorTheme: colorTheme,
              elevationTheme: elevationTheme,
              shapeTheme: shapeTheme,
              stateTheme: stateTheme,
              size: .extraSmall,
              width: .wide,
              color: .tonal,
              tapTargetSize: .shrinkWrap,
            ),
            onPressed: () => onSortChanged(
              SortDetails(sort: selected, order: order.flipped),
            ),
            icon: AnimatedRotation(
              turns: order == Sort.asc ? 0 : 0.5,
              duration: Durations.long2,
              curve: Curves.easeInOutCubicEmphasized,
              child: const Icon(MaterialSymbols.arrow_upward_rounded),
            ),
            tooltip: order == Sort.asc
                ? localizations.sort_ascending
                : localizations.sort_descending,
          ),
        ),

        Flexible.tight(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Flex.horizontal(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                ...types.mapIndexed(
                  (index, type) => SizedTouchTarget(
                    minimumSize: const .square(48.0),
                    child: FilledButton(
                      style: LegacyThemeFactory.createButtonStyle(
                        colorTheme: colorTheme,
                        elevationTheme: elevationTheme,
                        shapeTheme: shapeTheme,
                        stateTheme: stateTheme,
                        typescaleTheme: typescaleTheme,
                        size: .extraSmall,
                        color: .tonal,
                        isSelected: selected == type.value,
                        tapTargetSize: .shrinkWrap,
                      ),
                      onPressed: () => onSortChanged(
                        SortDetails(sort: type.value, order: order),
                      ),
                      child: Flex.horizontal(
                        spacing: 4.0,
                        children: [
                          if (type.icon != null)
                            IconTheme.mergeWithData(
                              data: .from(
                                opticalSize: 20.0,
                                size: 20.0,
                                color: selected == type.value
                                    ? colorTheme.onSecondary
                                    : colorTheme.onSecondaryContainer,
                              ),
                              child: type.icon,
                            ),
                          Text(type.label),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SortType<T> {
  const SortType({required this.value, this.icon, required this.label});

  final T value;
  final Widget? icon;
  final String label;
}
