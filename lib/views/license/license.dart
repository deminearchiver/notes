import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/widgets/back_button.dart';
import 'package:notes/widgets/switcher/switcher.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LicensesView extends StatefulWidget {
  const LicensesView({super.key});

  @override
  State<LicensesView> createState() => _LicensesViewState();
}

class _LicensesViewState extends State<LicensesView> {
  final Future<_LicenseData> _licenses = LicenseRegistry.licenses
      .fold(
        _LicenseData(),
        (previous, element) => previous..addLicense(element),
      )
      .then(
        (value) => value
          ..removePackage("notes")
          ..sortPackages(),
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    return Scaffold(
      body: FutureBuilder(
        future: _licenses,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leadingWidth: 64,
                toolbarHeight: 64,
                leading: const BackIconButton(),
                title: Text(localizations.licensesPageTitle),
                // bottom: snapshot.connectionState == ConnectionState.waiting
                //     ? PreferredSize(
                //         preferredSize: Size.fromHeight(4),
                //         child: LinearProgressIndicator(),
                //       )
                //     : null,
              ),
              // SliverPadding(
              //   padding: const EdgeInsets.all(16),
              //   sliver: SliverList.list(
              //     children: [
              //       Text(
              //         "Licenses of awesome open source software ",
              //         style: theme.textTheme.bodyLarge,
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ),
              Switcher.sliverFade(
                duration: Durations.short4,
                sliver: KeyedSubtree(
                  key: ValueKey(snapshot.connectionState),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? SliverList.builder(
                          itemBuilder: (context, index) => Skeletonizer(
                            child: ListTile(
                              title: Text("Id eu id excepteur culpa"),
                              subtitle: Text("Aliquip ipsum"),
                            ),
                          ),
                        )
                      : SliverList.builder(
                          itemCount: snapshot.data!.packages.length,
                          itemBuilder: (context, index) {
                            final packageName = snapshot.data!.packages[index];
                            final bindings = snapshot.data!
                                    .packageLicenseBindings[packageName] ??
                                [];
                            final licenses = snapshot.data!.licenses
                                .whereIndexed(
                                  (index, element) => bindings.contains(index),
                                )
                                .toList();
                            return ListTile(
                              onTap: licenses.isNotEmpty
                                  ? () => Navigator.push(
                                        context,
                                        MaterialRoute.sharedAxis(
                                          builder: (context) => _LicenseView(
                                            packageName: packageName,
                                            licenses: licenses,
                                          ),
                                        ),
                                      )
                                  : null,
                              title: Text(packageName),
                              subtitle: Text(
                                localizations
                                    .licensesPackageDetailText(licenses.length),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LicenseData {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    for (final String package in entry.packages) {
      _addPackage(package);
      packageLicenseBindings[package]!.add(licenses.length);
    }
    licenses.add(entry);
  }

  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  void removePackage(String package) {
    if (packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings.remove(package);
      packages.remove(package);
    }
    if (firstPackage == package) {
      firstPackage = null;
    }
  }

  void sortPackages([int Function(String a, String b)? compare]) {
    packages.sort(compare ??
        (String a, String b) {
          if (a == firstPackage) {
            return -1;
          }
          if (b == firstPackage) {
            return 1;
          }
          return a.toLowerCase().compareTo(b.toLowerCase());
        });
  }
}

class _LicenseView extends StatelessWidget {
  const _LicenseView({
    super.key,
    required this.packageName,
    required this.licenses,
  });

  final String packageName;
  final List<LicenseEntry> licenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: 64,
            toolbarHeight: 64,
            leading: const BackIconButton(),
            title: Text(packageName),
          ),
        ],
      ),
    );
  }
}
