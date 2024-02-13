import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:true_material/material.dart';

import 'package:intl/locale.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

// https://gist.github.com/AngDrew/569bdd51742687d5526a8257b7f1eb8f
Future<void> loadImage(ImageProvider provider) {
  final ImageConfiguration config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: MediaQueryData.fromView(WidgetsBinding.instance.window)
        .devicePixelRatio,
    platform: defaultTargetPlatform,
  );
  final completer = Completer<void>();
  final stream = provider.resolve(config);

  late final ImageStreamListener listener;

  listener = ImageStreamListener((image, sync) {
    debugPrint('Image ${image.debugLabel} finished loading');
    completer.complete();
    stream.removeListener(listener);
  }, onError: (Object exception, StackTrace? stackTrace) {
    completer.complete();
    stream.removeListener(listener);
    FlutterError.reportError(FlutterErrorDetails(
      context: ErrorDescription("Image failed to load!"),
      library: "Image resource service",
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  });

  stream.addListener(listener);
  return completer.future;
}

Locale parseLocale(String rawLocale) {
  final intlLocale = intl.Locale.parse(rawLocale);
  return Locale.fromSubtags(
    languageCode: intlLocale.languageCode,
    countryCode: intlLocale.countryCode,
    scriptCode: intlLocale.scriptCode,
  );
}

Locale? tryParseLocale(String rawLocale) {
  final intlLocale = intl.Locale.tryParse(rawLocale);
  if (intlLocale != null) {
    return Locale.fromSubtags(
        languageCode: intlLocale.languageCode,
        countryCode: intlLocale.countryCode,
        scriptCode: intlLocale.scriptCode);
  }
  return null;
}

Future<bool> openUrlString(String? value) async {
  if (value == null) return false;
  final url = Uri.tryParse(value);
  if (url == null) return false;
  if (!(await canLaunchUrl(url))) return false;
  return await launchUrl(url);
}

class BorderSideTween extends Tween<BorderSide> {
  BorderSideTween({super.begin, super.end});

  @override
  BorderSide lerp(double t) => BorderSide.lerp(
        begin ?? BorderSide.none,
        end ?? BorderSide.none,
        t,
      );
}
