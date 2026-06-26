import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/di/injection.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

void runStarterApp(AppConfig config) {
  runApp(StarterApp(config: config));
}

class StarterApp extends StatefulWidget {
  factory StarterApp({
    required AppConfig config,
    String? initialLocation,
    FakeSessionDataSource? sessionDataSource,
    Key? key,
  }) {
    final dependencies = GetIt.asNewInstance();
    configureDependencies(
      instance: dependencies,
      config: config,
      initialLocation: initialLocation,
      sessionDataSource: sessionDataSource,
    );

    return StarterApp.withDependencies(
      dependencies: dependencies,
      disposeDependencies: true,
      key: key,
    );
  }

  const StarterApp.withDependencies({
    required this.dependencies,
    this.disposeDependencies = false,
    super.key,
  }) : config = null,
       initialLocation = null,
       sessionDataSource = null;

  final GetIt dependencies;
  final bool disposeDependencies;
  final AppConfig? config;
  final String? initialLocation;
  final FakeSessionDataSource? sessionDataSource;

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = widget.dependencies<GoRouter>();
  }

  @override
  void dispose() {
    if (widget.disposeDependencies) {
      unawaited(widget.dependencies.reset());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.dependencies<AppConfig>();

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDev,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
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
