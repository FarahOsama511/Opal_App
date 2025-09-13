import 'package:Opal/core/get_it.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/network/local_network.dart';
import 'features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'features/Admin/presentaion/bloc/update_admin_supervisor/update_admin_supervisor_cubit.dart';
import 'features/user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import 'features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import 'features/user/presentaion/bloc/user_cubit.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization();
  //  await di.init();
  await initializeDateFormatting('ar', null);
  runApp(StudentBusApp());
}

class StudentBusApp extends StatelessWidget {
  StudentBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.setUp<TourCubit>()),
            BlocProvider(create: (_) => di.setUp<LinesCubit>()),
            BlocProvider(create: (_) => di.setUp<UpdateAddDeleteTourCubit>()),
            BlocProvider(create: (_) => di.setUp<SelectionTourCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllUniversitiesCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllDownTownCubit>()),
            // BlocProvider(create: (_) => di.setUp<GetUniversityByIdCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllUserCubit>()),
            BlocProvider(
              create: (_) => di.setUp<UpdateAdminOrSupervisorCubit>(),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'), // اللغة العربية
            ],
            title: 'Opal',
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
