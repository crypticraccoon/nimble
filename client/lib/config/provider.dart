import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/data/services/api/client.dart';
import 'package:client/data/services/shared_prefrences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create:
          (context) => AuthApiClient(
            //url: "http://0.0.0.0:3000/v1",
						url: "http://18.222.130.128:80/v1"
          ),
    ),
    //Provider(create: (context) => ApiClient()),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create:
          (context) =>
              AuthRepositoryRemote(
                    authApiClient: context.read(),
                    //apiClient: context.read(),
                    sharedPreferencesService: context.read(),
                  )
                  as AuthRepository,
    ),
  ];
}
