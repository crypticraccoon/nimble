import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/routing/routes.dart';
import 'package:client/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:client/ui/auth/login/widgets/login_screen.dart';
import 'package:client/ui/home/widgets/home_screen.dart';
import 'package:client/ui/recover/recover/view_mode/recover_viewmodel.dart';
import 'package:client/ui/recover/recover/widgets/recovery_screen.dart';
import 'package:client/ui/recover/update/view_mode/update_password_viewmodel.dart';
import 'package:client/ui/recover/update/widgets/update_screen.dart';
import 'package:client/ui/registration/newuser/view_model/newser_screen.dart';
import 'package:client/ui/registration/newuser/view_model/registration_viewmodel.dart';
import 'package:client/ui/registration/newuser/widgets/newuser_viewmodel.dart';
import 'package:client/ui/registration/registration/widgets/registration_screen.dart';
import 'package:client/ui/settings/settings/view_models/settings_viewmodel.dart';
import 'package:client/ui/settings/settings/widgets/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  debugLogDiagnostics: true,
  refreshListenable: authRepository,
  redirect: _redirect,
  initialLocation: Routes.home,
  routes: [_login(), _home()],
);

GoRoute _login() {
  return GoRoute(
    path: Routes.login,
    builder: (context, state) {
      return LoginScreen(
        viewModel: LoginViewModel(authRepository: context.read()),
      );
    },
    routes: [_recovery(), _register()],
  );
}

GoRoute _recovery() {
  return GoRoute(
    path: Routes.recover,

    builder: (context, state) {
      return RecoveryScreen(
        viewModel: RecoverViewmodel(authRepository: context.read()),
      );
    },

    routes: [
      GoRoute(
        path: Routes.recoveryUpdate,
        builder: (context, state) {
          return UpdateScreen(
            email: state.pathParameters['email']!,
            code: state.pathParameters['code']!,
            viewModel: UpdatePasswordViewmodel(authRepository: context.read()),
          );
        },
      ),
    ],
  );
}

GoRoute _register() {
  return GoRoute(
    path: Routes.register,
    builder: (context, state) {
      return RegistrationScreen(
        viewModel: RegistrationViewmodel(authRepository: context.read()),
      );
    },

    routes: [
      GoRoute(
        path: Routes.registerAddUserData,
        builder: (context, state) {
          return NewUserScreen(
            id: state.pathParameters['id']!,
            code: state.pathParameters['code']!,
            viewModel: NewUserViewmodel(authRepository: context.read()),
          );
        },
      ),
    ],
  );
}

GoRoute _home() {
  return GoRoute(
    path: Routes.home,
    builder: (context, state) {
      return HomeScreen(
        //viewModel: LoginViewModel(authRepository: context.read()),
      );
    },
    routes: [_settings()],
  );
}

GoRoute _settings() {
  return GoRoute(
    path: Routes.settings,
    builder: (context, state) {
      return SettingsScreen(
        viewModel: SettingsViewModel(authRepository: context.read()),
      );
    },
    routes: [],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final isUserLoggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  final register = state.matchedLocation.contains(Routes.register);
  final recover = state.matchedLocation.contains(Routes.recover);
  if (!isUserLoggedIn && !recover && !register) {
    return Routes.login;
  }

  if (loggingIn) {
    return Routes.home;
  }

  return null;
}
