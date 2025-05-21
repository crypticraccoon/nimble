import 'package:client/data/repositories/api_repository.dart';
import 'package:client/router/routes.dart';
import 'package:client/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:client/ui/auth/login/widgets/login_screen.dart';
import 'package:client/ui/home/view_models/home_viewmodel.dart';
import 'package:client/ui/home/widgets/home_screen.dart';
import 'package:client/ui/recover/recover/view_mode/recover_viewmodel.dart';
import 'package:client/ui/recover/recover/widgets/recovery_screen.dart';
import 'package:client/ui/recover/update/view_mode/update_password_viewmodel.dart';
import 'package:client/ui/recover/update/widgets/update_screen.dart';
import 'package:client/ui/registration/newuser/view_model/newser_screen.dart';
import 'package:client/ui/registration/newuser/view_model/registration_viewmodel.dart';
import 'package:client/ui/registration/newuser/widgets/newuser_viewmodel.dart';
import 'package:client/ui/registration/registration/widgets/registration_screen.dart';
import 'package:client/ui/settings/email/view_models/update_email_viewmodel.dart';
import 'package:client/ui/settings/email/widgets/update_email_screen.dart';
import 'package:client/ui/settings/password/view_models/update_password_viewmodel.dart';
import 'package:client/ui/settings/password/widgets/update_password_screen.dart';
import 'package:client/ui/settings/settings/view_models/settings_viewmodel.dart';
import 'package:client/ui/settings/settings/widgets/setting_screen.dart';
import 'package:client/ui/settings/username/view_models/update_username_viewmodel.dart';
import 'package:client/ui/settings/username/widgets/update_username_screen.dart';
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
        viewModel: RecoveryViewmodel(recoveryRepository: context.read()),
      );
    },

    routes: [
      GoRoute(
        path: Routes.recoveryUpdate,
        builder: (context, state) {
          return UpdateScreen(
            email: state.pathParameters['email']!,
            code: state.pathParameters['code']!,
            viewModel: UpdatePasswordViewmodel(
              recoveryRepository: context.read(),
            ),
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
        viewModel: RegistrationViewmodel(
          registrationRepository: context.read(),
        ),
      );
    },

    routes: [
      GoRoute(
        path: Routes.registerAddUserData,
        builder: (context, state) {
          return NewUserScreen(
            id: state.pathParameters['id']!,
            code: state.pathParameters['code']!,
            viewModel: NewUserViewmodel(registrationRepository: context.read()),
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
      final viewModel = HomeViewModel(
        userRepository: context.read(),
        todoRepository: context.read(),
        sharedPrefrences: context.read(),
      );
      viewModel.loadUserData.execute();
      viewModel.getUsername.execute();
      return HomeScreen(
        viewModel: HomeViewModel(
          userRepository: context.read(),
          todoRepository: context.read(),
          sharedPrefrences: context.read(),
        ),
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
        viewModel: SettingsViewModel(
          userRepository: context.read(),
          authRepository: context.read(),
        ),
      );
    },
    routes: [
      GoRoute(
        path: Routes.settingsUpdateUsername,
        builder: (context, state) {
          return UpdateUsernameScreen(
            viewModel: UpdateUsernameViewmodel(userRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.settingsUpdatePassword,
        builder: (context, state) {
          return UpdatePasswordScreen(
            viewModel: UpdatePasswordViewModel(userRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.settingsUpdateEmail,
        builder: (context, state) {
          return UpdateEmailScreen(
            viewModel: UpdateEmailViewmodel(userRepository: context.read()),
          );
        },
      ),
    ],
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
