# Changelog

## Unreleased

### Added

- working on **FULL SUPPORT** for window size classes (medium, expanded, large & extra-large)
- `AnimatedTitleBar` widget
- a custom app bar containing a search bar
- custom title bar for **Windows** & **macOS**

## [1.2.0] - 2024-03-21

This is a small release mainly focusing on visual improvements, making the app feel more immersive and easier to use.

### Notable changes

- reworked the about page
- added basic window sizes support

### Added

- added "**Clear**" button to the search bar

### Changed

- new visuals for the "**About app**" page
- reworked "**Nothing found**" widget
- removed app bar from the home screen and moved the settings button to the search bar
- made the `CurveTween`'s only argument positional
- improved Material 3 fidelity:
  - increased `SectionHeader` padding
  - reworked the routes *(once again)*
  - added hero widget for the back button
  - changed scroll to top button variant to `ElevatedButton`

### Fixed

- onboarding flow now prefers portrait orientation instead of landscape
- sorting options are now pinned
- some localization fixes

### Removed

- FABs' labels
- settings "**General**" page

## [1.1.0] - 2024-03-11

This is mainly a technical release, focusing on migrations, bug fixes and other technical improvements.

### Notable changes

- changed Flutter update channel to `main`
- migrated to **Isar v4** (from [**isar-community**](https://github.com/isar-community))
- changed internal package name to `material`
- added information about the project into [**README.md**](README.md)

### Changed

- migrated to `main` Flutter update channel
- migrated to `material` local package
- migrated to version 4 of Isar Database
- bumpted Android compile SDK version to 34
- separated theme code from application code
- introduced a new route animation behaviour
- replaced old Material routes with new ones
- deprecated `InteractiveIcon`
- unnamed note name is now `Note (#)` instead of `... (#)`

### Fixed

- improved Material 3 fidelity:
  - outline color of disabled cards
  - search bar leading icon now has the same size as the leading icon button according to visual density
  - changed scroll to top button variant to "filled tonal"
  - changed onboarding "Next" button variant to "filled tonal"
  - removed `scrolledUnderElevation` from app bars
  - added missing list padding on the "Home" page
  - changed scrim color (black) opacity to `0.32` (according to Material 3 spec)
  - changed onboarding icon color from secondary to primary
- "About" page now properly displays application version

### Removed

- `WindowClass` enum / extension (moved to internal package)
- `TweenedIcon` widget (moved to internal package)
- Github Actions

### Security

- **Isar v4** now supports **database encryption**

[1.2.0]: https://github.com/deminearchiver/notes/releases/v1.2.0
[1.1.0]: https://github.com/deminearchiver/notes/releases/v1.1.0