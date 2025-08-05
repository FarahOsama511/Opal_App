import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:opal_app/core/network/network_info.dart';
import 'package:opal_app/features/Admin/Data/dataSource/add_admin_supervisor_datasource.dart';
import 'package:opal_app/features/Admin/Data/dataSource/line_local_data_source.dart';
import 'package:opal_app/features/Admin/Data/dataSource/line_remote_data_source.dart';
import 'package:opal_app/features/Admin/Data/dataSource/tour_local_data_source.dart';
import 'package:opal_app/features/Admin/Data/dataSource/tour_remote_data_source.dart';
import 'package:opal_app/features/Admin/Data/repositiries/add_admin_supervisor_repo_impl.dart';
import 'package:opal_app/features/Admin/Data/repositiries/line_repo_impl.dart';
import 'package:opal_app/features/Admin/Data/repositiries/tour_repo_impl.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/add_admin_supervisor.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_admin_supervisor.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_line_use_case.dart';
import 'package:opal_app/features/Admin/Domain/usecase/get_all_lines.dart';
import 'package:opal_app/features/Admin/Domain/usecase/get_all_tours.dart';
import 'package:opal_app/features/Admin/Domain/usecase/get_tour_id_use_case.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_cubit.dart';
import 'package:opal_app/features/user/Data/datasource/select_tour_remote_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/university_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/university_local_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/user_local_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/user_remote_data_source.dart';
import 'package:opal_app/features/user/Data/repositiries/selection_tour_repo_impl.dart';
import 'package:opal_app/features/user/Data/repositiries/university_repo_impl.dart';
import 'package:opal_app/features/user/Data/repositiries/user_repo_impl.dart';
import 'package:opal_app/features/user/Domain/repositires/select_tour_repo.dart';
import 'package:opal_app/features/user/Domain/repositires/university_repo.dart';
import 'package:opal_app/features/user/Domain/repositires/user_repo.dart';
import 'package:opal_app/features/user/Domain/usecases/get_all_univeristies.dart';
import 'package:opal_app/features/user/Domain/usecases/get_all_user.dart';
import 'package:opal_app/features/user/Domain/usecases/get_user_id_use_case.dart';
import 'package:opal_app/features/user/Domain/usecases/select_tour_use_case.dart';
import 'package:opal_app/features/user/Domain/usecases/unconfirm_tour_use_case.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/Admin/Domain/reporistires/tour_repo.dart';
import '../features/Admin/Domain/usecase/add_tour.dart';
import '../features/Admin/Domain/usecase/delete_tour.dart';
import '../features/Admin/Domain/usecase/update_tour.dart';
import '../features/Admin/presentaion/bloc/create_admin_supervisors.dart/add_admin_supervisor_cubit.dart';
import '../features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import '../features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import '../features/user/Data/datasource/remote_data_source.dart';
import '../features/user/Data/repositiries/auth_repo_impl.dart';
import '../features/user/Domain/repositires/auth_repo.dart';
import '../features/user/Domain/usecases/login_usecase.dart';
import '../features/user/Domain/usecases/register_usecase.dart';
import '../features/user/Domain/usecases/user_isactivat.dart';
import '../features/user/Domain/usecases/user_isdeactivat_UseCase.dart';

final setUp = GetIt.instance;
Future<void> init() async {
  //cubits
  setUp.registerFactory(() => TourCubit(setUp()));
  setUp.registerFactory(
    () => UpdateAddDeleteTourCubit(setUp(), setUp(), setUp()),
  );
  setUp.registerFactory(
    () => AuthCubit(loginUsecase: setUp(), registerUsecase: setUp()),
  );
  setUp.registerFactory(
    () => GetAllUserCubit(setUp(), setUp(), setUp(), setUp()),
  );
  setUp.registerFactory(() => LinesCubit(setUp()));
  setUp.registerFactory(() => AddAdminSupervisorCubit(setUp()));
  setUp.registerFactory(() => GetAllUniversitiesCubit(setUp()));
  setUp.registerFactory(() => AddLineCubit(setUp()));
  setUp.registerFactory(() => SelectionTourCubit(setUp(), setUp()));
  setUp.registerFactory(() => GetTourIdCubit(setUp()));

  //usecases
  setUp.registerLazySingleton(() => GetAllToursUseCase(setUp()));
  setUp.registerLazySingleton(() => AddTourUseCase(setUp()));
  setUp.registerLazySingleton(() => DeleteTourUseCase(setUp()));
  setUp.registerLazySingleton(() => UpdateTourUseCase(setUp()));
  setUp.registerLazySingleton(() => LoginUsecase(setUp()));
  setUp.registerLazySingleton(() => RegisterUsecase(setUp()));
  setUp.registerLazySingleton(() => GetAllUserUseCase(setUp()));
  setUp.registerLazySingleton(() => GetAllLinesUseCase(setUp()));
  setUp.registerLazySingleton(() => UserIsactivatUseCase(setUp()));
  setUp.registerLazySingleton(() => UserIsDeactivatUseCase(setUp()));
  setUp.registerLazySingleton(() => AddAdminSupervisorUseCase(setUp()));
  setUp.registerLazySingleton(() => GetAllUniveristiesUseCase(setUp()));
  setUp.registerLazySingleton(() => GetTourByIdUseCase(setUp()));
  setUp.registerLazySingleton(() => AddLineUseCase(setUp()));
  setUp.registerLazySingleton(() => SelectionTourUseCase(setUp()));
  setUp.registerLazySingleton(() => UnconfirmTourUseCase(setUp()));
  setUp.registerLazySingleton(() => GetUserIdUseCase(setUp()));

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
  setUp.registerLazySingleton<UserRepo>(
    () => UserRepoImpl(
      userLocalDataSource: setUp(),
      networkInfo: setUp(),
      userRemoteDataSource: setUp(),
    ),
  );
  setUp.registerLazySingleton<LineRepo>(
    () => LineRepoImpl(
      setUp(),
      remoteDataSource: setUp(),
      lineLocalDataSource: setUp(),
    ),
  );
  setUp.registerLazySingleton<AddAdminORSupervisorRepo>(
    () => AddAdminSupervisorRepoImpl(setUp(), setUp()),
  );
  setUp.registerLazySingleton<UniversityRepo>(
    () => UniversityRepoImpl(
      universityDataSource: setUp(),
      networkInfo: setUp(),
      universityLocalDataSource: setUp(),
    ),
  );
  setUp.registerLazySingleton<SelectionTourRepo>(
    () => SelectionTourRepoImpl(
      selectTourRemoteDataSource: setUp(),
      networkInfo: setUp(),
    ),
  );

  //data sources
  setUp.registerLazySingleton<TourRemoteDataSource>(
    () => TourRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<LocalDataSource>(() => TourLocalDataSourceImpl());
  setUp.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(prefs: setUp()),
  );
  setUp.registerLazySingleton<LineRemoteDataSource>(
    () => LineRemoteDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<LineLocalDataSource>(
    () => LineLocalDataSourceImpl(),
  );
  setUp.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: setUp()),
  );
  setUp.registerLazySingleton<AddAdminSupervisorDatasource>(
    () => AddAdminSupervisorDatasourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<UniversityDataSource>(
    () => UniversityDataSourceImpl(client: setUp()),
  );
  setUp.registerLazySingleton<UniversityLocalDataSource>(
    () => UniversityLocalDataSourceImpl(),
  );
  setUp.registerLazySingleton<SelectTourRemoteDataSource>(
    () => SelectTourRemoteDataSourceImpl(client: setUp()),
  );

  //external dependencies
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setUp.registerLazySingleton(() => prefs);
  setUp.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  setUp.registerLazySingleton(() => http.Client());
}
