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
export 'package:notes/flutter.dart';
export 'package:linked_layouts/linked_layouts.dart';
export 'package:touch_targets/touch_targets.dart';

import 'package:notes/flutter.dart';

class AdaptiveDestination {
  const AdaptiveDestination({
    this.enabled = true,
    required this.icon,
    this.selectedIcon,
    required this.label,
  });

  final bool enabled;
  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  NavigationDestination get barDestination => NavigationDestination(
    enabled: enabled,
    icon: icon,
    selectedIcon: selectedIcon,
    label: label,
  );

  NavigationRailDestination get railDestination => NavigationRailDestination(
    disabled: !enabled,
    icon: icon,
    selectedIcon: selectedIcon,
    label: Text(label),
  );

  NavigationDrawerDestination get drawerDestination =>
      NavigationDrawerDestination(
        enabled: enabled,
        icon: icon,
        selectedIcon: selectedIcon,
        label: Text(label),
      );
}

extension AdaptiveDestinationListExtension on Iterable<AdaptiveDestination> {
  Iterable<NavigationDestination> toBarDestinations() =>
      map((destination) => destination.barDestination);

  Iterable<NavigationRailDestination> toRailDestinations() =>
      map((destination) => destination.railDestination);

  Iterable<NavigationDrawerDestination> toDrawerDestinations() =>
      map((destination) => destination.drawerDestination);
}

class AdaptiveTopLevelDelegate {
  const AdaptiveTopLevelDelegate({
    required this.onDestinationSelected,
    required this.selectedIndex,
    required this.destinations,
  }) : assert(destinations.length >= 2);

  final ValueChanged<int>? onDestinationSelected;
  final int selectedIndex;
  final List<AdaptiveDestination> destinations;
}

class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    super.key,
    required this.topLevelDelegate,
    this.floatingActionButton,
    this.body,
  });

  final AdaptiveTopLevelDelegate topLevelDelegate;
  final Widget? floatingActionButton;
  final Widget? body;

  static AdaptiveScaffoldState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AdaptiveScaffoldState>();
  }

  static AdaptiveScaffoldState of(BuildContext context) {
    return maybeOf(context)!;
  }

  @override
  State<AdaptiveScaffold> createState() => AdaptiveScaffoldState();
}

class AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _contentNavigator = GlobalKey<NavigatorState>();
  final _listPaneNavigator = GlobalKey<NavigatorState>();
  final _detailsPaneNavigator = GlobalKey<NavigatorState>();

  void openNavigationDrawer() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainer;
    final windowWidthSizeClass = WindowWidthSizeClass.of(context);

    final useTwoPaneLayout =
        windowWidthSizeClass >= WindowWidthSizeClass.medium;
    final useNavigationRail =
        windowWidthSizeClass > WindowWidthSizeClass.medium &&
        windowWidthSizeClass < WindowWidthSizeClass.extraLarge;
    final useNavigationDrawer =
        windowWidthSizeClass >= WindowWidthSizeClass.extraLarge;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: useTwoPaneLayout ? backgroundColor : null,
      floatingActionButton: windowWidthSizeClass <= WindowWidthSizeClass.medium
          ? widget.floatingActionButton
          : null,
      // bottomNavigationBar: windowWidthSizeClass <= WindowWidthSizeClass.medium
      //     ? NavigationBar(
      //         onDestinationSelected:
      //             widget.topLevelDelegate.onDestinationSelected,
      //         selectedIndex: widget.topLevelDelegate.selectedIndex,
      //         destinations:
      //             widget.topLevelDelegate.destinations.toBarDestinations(),
      //       )
      //     : null,
      bottomNavigationBar: ClipRect(
        child: AnimatedAlign(
          duration: Durations.long4,
          curve: Curves.easeInOutCubicEmphasized,
          alignment: Alignment.topCenter,
          heightFactor: windowWidthSizeClass <= WindowWidthSizeClass.medium
              ? 1
              : 0,
          child: NavigationBar(
            onDestinationSelected:
                widget.topLevelDelegate.onDestinationSelected,
            selectedIndex: widget.topLevelDelegate.selectedIndex,
            destinations: widget.topLevelDelegate.destinations
                .toBarDestinations()
                .toList(growable: false),
          ),
        ),
      ),
      drawer: useNavigationRail
          ? NavigationDrawer(
              onDestinationSelected: (value) {
                widget.topLevelDelegate.onDestinationSelected?.call(value);
                _scaffoldKey.currentState?.closeDrawer();
              },
              selectedIndex: widget.topLevelDelegate.selectedIndex,
              children: [
                ...widget.topLevelDelegate.destinations.toDrawerDestinations(),
              ],
            )
          : null,
      body: Flex.horizontal(
        children: [
          ClipRect(
            child: AnimatedAlign(
              duration: Durations.long4,
              curve: Curves.easeInOutCubicEmphasized,
              alignment: Alignment.centerRight,
              widthFactor: useNavigationRail ? 1 : 0,
              child: NavigationRail(
                leading: widget.floatingActionButton != null
                    ? Flex.vertical(
                        children: [
                          IconButton(
                            onPressed: _scaffoldKey.currentState?.openDrawer,
                            icon: const Icon(MaterialSymbols.menu_rounded),
                          ),
                          const SizedBox(height: 12),
                          widget.floatingActionButton!,
                          const SizedBox(height: 8),
                        ],
                      )
                    : IconButton(
                        onPressed: _scaffoldKey.currentState?.openDrawer,
                        icon: const Icon(MaterialSymbols.menu_rounded),
                      ),
                backgroundColor: backgroundColor,
                onDestinationSelected:
                    widget.topLevelDelegate.onDestinationSelected,
                selectedIndex: widget.topLevelDelegate.selectedIndex,
                labelType: NavigationRailLabelType.all,
                destinations: widget.topLevelDelegate.destinations
                    .toRailDestinations()
                    .toList(growable: false),
              ),
            ),
          ),
          if (useNavigationDrawer)
            NavigationDrawer(
              onDestinationSelected:
                  widget.topLevelDelegate.onDestinationSelected,
              selectedIndex: widget.topLevelDelegate.selectedIndex,
              backgroundColor: backgroundColor,
              children: [
                ...widget.topLevelDelegate.destinations.toDrawerDestinations(),
              ],
            ),
          if (widget.body != null) Flexible.tight(child: widget.body!),
        ],
      ),
    );
  }
}
