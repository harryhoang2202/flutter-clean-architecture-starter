import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/app/di/app_dependencies.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/layout/responsive_constraints.dart';
import 'package:flutter_clean_architecture_starter/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

void runStarterApp(AppConfig config) {
  runApp(StarterApp(dependencies: AppDependencies.create(config: config)));
}

class StarterApp extends StatefulWidget {
  const StarterApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = widget.dependencies.router;
  }

  @override
  void dispose() {
    unawaited(widget.dependencies.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.dependencies.config;

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDev,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      routerConfig: _router,
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
      body: ResponsiveConstraints(
        maxWidth: 520,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
    );
  }
}
