import 'package:fleather/fleather.dart';
import 'package:notes/flutter.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class CustomFleatherThemeData {
  static FleatherThemeData fallback(ThemeData theme) {
    final baseStyle = theme.textTheme.bodyMedium!;
    const baseSpacing = VerticalSpacing(top: 6, bottom: 10);

    final codeStyle = TextStyle(
      fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
    );

    return FleatherThemeData(
      paragraph: TextBlockTheme(style: baseStyle, spacing: baseSpacing),
      bold: const TextStyle(fontWeight: FontWeight.bold),
      italic: const TextStyle(fontStyle: FontStyle.italic),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      link: TextStyle(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      heading1: TextBlockTheme(
        style: theme.textTheme.headlineMedium!,
        spacing: const VerticalSpacing(bottom: 8),
      ),
      heading2: TextBlockTheme(
        style: theme.textTheme.titleLarge!,
        spacing: const VerticalSpacing(bottom: 6),
      ),
      heading3: TextBlockTheme(
        style: theme.textTheme.titleMedium!,
        spacing: const VerticalSpacing(bottom: 4),
      ),
      heading4: TextBlockTheme(
        style: theme.textTheme.labelLarge!,
        spacing: const VerticalSpacing(bottom: 2),
      ),
      heading5: TextBlockTheme(
        style: theme.textTheme.labelMedium!,
        spacing: const VerticalSpacing(),
      ),
      heading6: TextBlockTheme(
        style: theme.textTheme.labelSmall!,
        spacing: const VerticalSpacing(),
      ),
      code: TextBlockTheme(
        style: codeStyle,
        spacing: const VerticalSpacing(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.colorScheme.outline),
        ),
      ),
      inlineCode: InlineCodeThemeData(
        style: codeStyle,
        backgroundColor: theme.colorScheme.surface,
      ),
      lists: TextBlockTheme(
        style: const TextStyle(),
        lineSpacing: const VerticalSpacing(top: 16, bottom: 16),
        spacing: const VerticalSpacing(),
      ),
      quote: TextBlockTheme(
        style: const TextStyle(fontStyle: FontStyle.italic),
        spacing: const VerticalSpacing(),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.disabledColor, width: 4),
          ),
        ),
      ),
      horizontalRule: HorizontalRuleThemeData(
        height: 16.0,
        thickness: 1.0,
        color: theme.colorScheme.outlineVariant,
      ),
    );
  }
}

const appBarTheme = AppBarTheme(toolbarHeight: 64);

class AppTheme {
  static ThemeData createTheme({required Brightness brightness}) {
    return ThemeData(
      brightness: brightness,
      splashFactory: InkSparkle.splashFactory,
      // visualDensity: VisualDensity.standard,
      platform: TargetPlatform.android,
      searchBarTheme: const SearchBarThemeData(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        shadowColor: WidgetStateColor.transparent,
      ),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    );
  }

  static ThemeData light() => createTheme(brightness: Brightness.light);
  static ThemeData dark() => createTheme(brightness: Brightness.dark);
}
