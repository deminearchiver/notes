library;

// SDK packages

export 'package:flutter/foundation.dart' hide clampDouble;

export 'package:flutter/services.dart';

export 'package:flutter/physics.dart';

export 'package:flutter/rendering.dart'
    hide
        ChildLayoutHelper,
        FlexParentData,
        FloatingHeaderSnapConfiguration,
        OverScrollHeaderStretchConfiguration,
        PersistentHeaderShowOnScreenConfiguration,
        RenderFlex,
        RenderPadding;

export 'package:flutter/material.dart'
    hide
        // package:layout
        // ---
        Padding,
        Align,
        Center,
        Flex,
        Row,
        Column,
        Flexible,
        Expanded,
        Spacer,
        // ---
        // package:material
        // ---
        DynamicSchemeVariant,
        // ---
        WidgetStateProperty,
        WidgetStatesConstraint,
        WidgetStateMap,
        WidgetStateMapper,
        WidgetStatePropertyAll,
        WidgetStatesController,
        // ---
        Material,
        MaterialType,
        // ---
        Icon,
        IconTheme,
        IconThemeData,
        // ---
        // Force migration to Material Symbols
        Icons,
        AnimatedIcons,
        // ---
        CircularProgressIndicator,
        LinearProgressIndicator,
        ProgressIndicator,
        // ---
        Checkbox,
        CheckboxTheme,
        CheckboxThemeData,
        // ---
        Switch,
        SwitchTheme,
        SwitchThemeData;

// Third-party packages

export 'package:meta/meta.dart';
export 'package:layout/layout.dart';
export 'package:material/material.dart';
export 'package:touch_targets/touch_targets.dart';
export 'package:linked_layouts/linked_layouts.dart';
export 'package:provider/provider.dart'
    hide ReadContext, WatchContext, SelectContext;

export 'i18n/i18n.dart';
export 'theme/legacy.dart';
export 'theme/typography.dart';

import 'package:notes/flutter.dart';
import 'package:provider/provider.dart';

class InheritedProviderSelector<ProviderType extends Object> {
  const InheritedProviderSelector();

  ProviderType? maybeOf(BuildContext context, {bool listen = true}) =>
      Provider.of<ProviderType?>(context, listen: listen);

  ProviderType of(BuildContext context, {bool listen = true}) =>
      Provider.of<ProviderType>(context, listen: listen);

  AspectType maybeAspectOf<AspectType extends Object?>(
    BuildContext context,
    AspectType Function(ProviderType? value) selector, {
    bool listen = true,
  }) => listen
      ? context.select<ProviderType?, AspectType>(selector)
      : selector(maybeOf(context, listen: false));

  AspectType aspectOf<AspectType extends Object?>(
    BuildContext context,
    AspectType Function(ProviderType value) selector, {
    bool listen = true,
  }) => listen
      ? context.select<ProviderType, AspectType>(selector)
      : selector(of(context, listen: false));
}
