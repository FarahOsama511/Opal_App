import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/get_it.dart' as di;
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_university/add_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_user/delete_user_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/pages/add_line.dart';
import 'package:opal_app/features/Admin/presentaion/pages/admin_home_screen.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trips.dart';
import 'package:opal_app/features/supervisor/presentation/pages/show_tours.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'features/Admin/presentaion/bloc/create_admin_supervisors.dart/add_admin_supervisor_cubit.dart';
import 'features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'features/Admin/presentaion/pages/add_admin.dart';
import 'features/Admin/presentaion/pages/add_supervisor.dart';
import 'features/Admin/presentaion/pages/add_university.dart';
import 'features/Admin/presentaion/pages/student_list.dart';
import 'features/supervisor/bloc/get_university_by_id/get_university_by_id_cubit.dart';
import 'features/user/presentaion/bloc/auth_cubit.dart';
import 'features/user/presentaion/pages/sign_in.dart';
import 'features/user/presentaion/pages/sign_up.dart';
import 'features/user/presentaion/pages/user_home_screen.dart';
import 'features/user/presentaion/pages/waiting_screen.dart';
import 'features/selection/presentation/pages/confirmation_success.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization();
  token = CacheNetwork.getCacheData(key: 'access_token');
  lines = CacheNetwork.getCacheData(key: "SAVE_LINES");
  tour = CacheNetwork.getCacheData(key: "SAVE_TOURS");
  users = CacheNetwork.getCacheData(key: "SAVE_USERS");
  universities = CacheNetwork.getCacheData(key: "SAVE_UNIVERSITIES");
  await di.init();
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
            BlocProvider(create: (_) => di.setUp<AuthCubit>()),
            BlocProvider(create: (_) => di.setUp<TourCubit>()),
            BlocProvider(create: (_) => di.setUp<UpdateAddDeleteTourCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllUserCubit>()),
            BlocProvider(create: (_) => di.setUp<LinesCubit>()..getAllLiness()),
            BlocProvider(create: (_) => di.setUp<AddLineCubit>()),
            BlocProvider(create: (_) => di.setUp<AddAdminSupervisorCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllUniversitiesCubit>()),
            BlocProvider(create: (_) => di.setUp<SelectionTourCubit>()),
            BlocProvider(create: (_) => di.setUp<GetTourIdCubit>()),
            BlocProvider(create: (_) => di.setUp<DeleteUserCubit>()),
            BlocProvider(create: (_) => di.setUp<GetUniversityByIdCubit>()),
            BlocProvider(create: (_) => di.setUp<AddUniversityCubit>()),
            BlocProvider(create: (_) => di.setUp<DeleteUniversityCubit>()),
            BlocProvider(create: (_) => di.setUp<DeleteLineCubit>()),
            BlocProvider(create: (_) => di.setUp<GetAllDownTownCubit>()),
          ],
          child: MaterialApp(
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

            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/signin': (context) => const SignInScreen(),
              '/waiting': (context) => const WaitingScreen(),
              '/home': (context) => const UserHomeScreen(),
              // '/supervisorScreen': (context) => ShowToursBySuperVisor(),
              '/success': (context) => const ConfirmationSuccessScreen(),
              '/students': (context) => const StudentList(),
              '/adminScreen': (context) => AdminHomeScreen(),
              '/addAdmin': (context) => const AddAdmin(),
              '/addSupervisor': (context) => AddSupervisor(),
              '/addLine': (context) => const AddLine(),
              '/addUniversity': (context) => const AddUniversity(),
              '/trips': (context) => const TripsScreen(),
            },
          ),
        );
      },
    );
  }
}
