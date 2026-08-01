import 'package:notes/flutter.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.icon});

  final Widget? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    return Padding(
      padding: const .fromSTEB(16.0, 12.0, 16.0, 8.0),
      child: Align.centerStart(
        child: Surface(
          clipBehavior: .antiAlias,
          shape: shapeTheme.applyCorner(corner: shapeTheme.cornerSmall),
          color: colorTheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Flex.horizontal(
              mainAxisSize: .min,
              children: [
                if (icon != null)
                  IconTheme.mergeWithData(
                    data: .from(
                      opticalSize: 24.0,
                      size: 16.0,
                      color: colorTheme.onSurfaceVariant,
                    ),
                    child: icon,
                  ),
                if (icon != null) const SizedBox(width: 4.0),
                Text(
                  text,
                  style: typescaleTheme.labelSmall.toTextStyle(
                    color: colorTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
