import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Licenses extends StatefulWidget {
  static const String routeName = "/licenses";

  const Licenses({super.key});

  @override
  State<Licenses> createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  final _scrollController = ScrollController();
  final _licenses = <_LicenseData>[];

  Future<void> _loadLicenses() async {
    final licenseMap = <String, List<String>>{};

    await for (final entry in LicenseRegistry.licenses) {
      final text = entry.paragraphs.map((p) => p.text).join('\n\n');
      for (final package in entry.packages) {
        licenseMap.putIfAbsent(package, () => []).add(text);
      }
    }

    setState(() {
      _licenses.addAll(
        licenseMap.entries
            .map((e) => _LicenseData(package: e.key, text: e.value.join('\n\n---\n\n')))
            .toList()
          ..sort((a, b) => a.package.compareTo(b.package)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Licenses and packages", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 7, 17, 7),
        child: Theme(
          data: Theme.of(context).copyWith(splashColor: Theme.of(context).colorScheme.secondaryContainer),
          child: Material(
            borderRadius: BorderRadiusGeometry.circular(8),
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
            surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _licenses.length,
                itemBuilder: (context, index) {
                  final license = _licenses[index];
                  return ExpansionTile(
                    title: Text(license.package, style: const TextStyle(fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SelectableText(
                          license.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LicenseData {
  final String package;
  final String text;
  const _LicenseData({required this.package, required this.text});
}
