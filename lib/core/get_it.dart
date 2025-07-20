import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:opal_app/core/network/network_info.dart';
import 'package:opal_app/features/Tours/Data/dataSource/local_data_source.dart';
import 'package:opal_app/features/Tours/Data/dataSource/remote_data_source.dart';
import 'package:opal_app/features/Tours/Data/repositiries/tour_repo_impl.dart';
import 'package:opal_app/features/Tours/Domain/usecase/get_all_tours.dart';
import 'package:opal_app/features/Tours/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'package:opal_app/features/auth/presentaion/bloc/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/Tours/Domain/reporistires/tour_repo.dart';
import '../features/Tours/Domain/usecase/add_tour.dart';
import '../features/Tours/Domain/usecase/delete_tour.dart';
import '../features/Tours/Domain/usecase/update_tour.dart';
import '../features/Tours/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import '../features/auth/Data/datasource/remote_data_source.dart';
import '../features/auth/Data/repositiries/auth_repo_impl.dart';
import '../features/auth/Domain/repositires/auth_repo.dart';
import '../features/auth/Domain/usecases/login_usecase.dart';
import '../features/auth/Domain/usecases/register_usecase.dart';

final setUp = GetIt.instance;
Future<void> init() async {
  //cubits
  setUp.registerFactory(() => TourCubit(setUp()));
  setUp.registerFactory(
    () => UpdateAddDeleteTourCubit(setUp(), setUp(), setUp(), setUp()),
  );
  setUp.registerFactory(
    () => AuthCubit(loginUsecase: setUp(), registerUsecase: setUp()),
  );

  //usecases
  setUp.registerLazySingleton(() => GetAllToursUseCase(setUp()));
  setUp.registerLazySingleton(() => AddTourUseCase(setUp()));
  setUp.registerLazySingleton(() => DeleteTourUseCase(setUp()));
  setUp.registerLazySingleton(() => UpdateTourUseCase(setUp()));
  setUp.registerLazySingleton(() => LoginUsecase(setUp()));
  setUp.registerLazySingleton(() => RegisterUsecase(setUp()));

  //repositories
  setUp.registerLazySingleton<ToursRepository>(
    () => TourRepoImpl(
      setUp(),
      localDataSource: setUp(),
      remoteDataSource: setUp(),
    ),
  );
  setUp.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(authremoteDataSource: setUp(), networkInfo: setUp()),
  );
  //data sources
  setUp.registerLazySingleton<TourRemoteDataSource>(
    () => TourRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<LocalDataSource>(
    () => TourLocalDataSourceImpl(prefs: setUp()),
  );
  setUp.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: setUp()),
  );
  //external dependencies
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setUp.registerLazySingleton(() => prefs);
  setUp.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  setUp.registerLazySingleton(() => http.Client());
}
