import 'package:notes/flutter.dart';

class const CustomIcon<T extends CustomIconResolver>(
  final T resolver, {
  super.key,
  final double? roundness,
  final double? fill,
  final double? weight,
  final double? grade,
  final double? opticalSize,
  final double? size,
  final Color? color,
  final List<Shadow>? shadows,
  final bool? applyTextScaling,
  final BlendMode? blendMode,
  final String? semanticLabel,
  final TextDirection? textDirection,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = resolver.resolve(context);
    return Icon(
      icon,
      roundness: roundness,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      size: size,
      color: color,
      shadows: shadows,
      applyTextScaling: applyTextScaling,
      blendMode: blendMode,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}

abstract interface class CustomIconResolver {
  IconData resolve(BuildContext context);
}
