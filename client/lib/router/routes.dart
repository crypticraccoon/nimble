abstract final class Routes {
  static const login = "/";

  //Registration Routes
  static const register = "/register";
  static const registerAddUserData = "/new/:id/:code";

  //Recovery Routes
  static const recover = "/recover";
  static const recoveryUpdate = "/update/:email/:code";

  // Todo
  static const home = "/home";
  static const todo = "/:id";

  // Settings
  static const settings = '/settings';
  static const settingsUpdatePassword = '/update/password';
  static const settingsUpdateUsername = '/update/username';
  static const settingsUpdateEmail = '/update/email';
}
