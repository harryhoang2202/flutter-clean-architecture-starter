enum AppEnvironment {
  dev('dev'),
  prod('prod');

  const AppEnvironment(this.label);

  final String label;
}
