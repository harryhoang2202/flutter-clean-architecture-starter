class AppRoutes {
  const AppRoutes._();

  static const authentication = '/authentication';
  static const projects = '/projects';

  static String projectDetail(String projectId) => '/projects/$projectId';
}
