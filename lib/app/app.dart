import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';

void runStarterApp(AppConfig config) {
  runApp(StarterApp(config: config));
}

class StarterApp extends StatelessWidget {
  const StarterApp({required this.config, super.key});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDev,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: StarterHomePage(config: config),
    );
  }
}

class StarterHomePage extends StatelessWidget {
  const StarterHomePage({required this.config, super.key});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.referenceStarterSubtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(strings.sliceZeroStatus(config.environment.label)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
