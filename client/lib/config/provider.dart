import 'package:client/data/repositories/api_repository.dart';
import 'package:client/data/services/api/api.dart';
import 'package:client/data/services/shared_prefrences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  const _url = "http://0.0.0.0:3000/v1";
  //const _url = "http://18.222.130.128:80/v1";

  return [
    Provider(create: (context) => ApiClient(url: _url)),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create:
          (context) => AuthRepository(
            apiClient: context.read(),
            sharedPreferencesService: context.read(),
          ),
    ),

    Provider(
      create: (context) => RegistrationRepository(apiClient: context.read()),
    ),

    Provider(
      create: (context) => RecoveryRepository(apiClient: context.read()),
    ),

    Provider(
      create:
          (context) => TodoRepository(
            sharedPreferencesService: context.read(),
            apiClient: context.read(),
            authRepository: context.read(),
          ),
    ),

    Provider(
      create:
          (context) => UserRepository(
            sharedPreferencesService: context.read(),
            apiClient: context.read(),
            authRepository: context.read(),
          ),
    ),
  ];
}
