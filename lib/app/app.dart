import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_router.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

void runStarterApp(AppConfig config) {
  runApp(StarterApp(config: config));
}

class StarterApp extends StatefulWidget {
  const StarterApp({
    required this.config,
    this.initialLocation,
    this.sessionDataSource,
    super.key,
  });

  final AppConfig config;
  final String? initialLocation;
  final FakeSessionDataSource? sessionDataSource;

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  late final FakeSessionDataSource _sessionDataSource;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _sessionDataSource =
        widget.sessionDataSource ?? FakeSessionDataSource.unauthenticated();
    _router = createAppRouter(
      sessionDataSource: _sessionDataSource,
      initialLocation: widget.initialLocation,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    if (widget.sessionDataSource == null) {
      _sessionDataSource.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: widget.config.appName,
      debugShowCheckedModeBanner: widget.config.isDev,
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
