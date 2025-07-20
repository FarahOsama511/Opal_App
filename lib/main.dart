import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:opal_app/core/get_it.dart' as di;
import 'features/Tours/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'features/Tours/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'features/auth/presentaion/bloc/auth_cubit.dart';
import 'features/auth/presentaion/pages/add_admin.dart';
import 'features/auth/presentaion/pages/add_supervisor.dart';
import 'features/auth/presentaion/pages/sign_in.dart';
import 'features/auth/presentaion/pages/sign_up.dart';
import 'features/auth/presentaion/pages/waiting_screen.dart';
import 'features/selection/presentation/pages/confirm_details.dart';
import 'features/selection/presentation/pages/confirmation_success.dart';
import 'features/selection/presentation/pages/return_time.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await initializeDateFormatting('ar', null);
  runApp(const StudentBusApp());
}

class StudentBusApp extends StatelessWidget {
  const StudentBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.setUp<TourCubit>()),
        BlocProvider(create: (_) => di.setUp<UpdateAddDeleteTourCubit>()),
        BlocProvider(create: (_) => di.setUp<AuthCubit>()),
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
        title: 'Student Bus App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Cairo', primarySwatch: Colors.pink),
        initialRoute: '/signup',
        routes: {
          //   '/': (context) => const SplashScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/signin': (context) => const SignInScreen(),
          '/waiting': (context) => const WaitingScreen(),
          // '/home': (context) => const HomeScreen(),
          '/return': (context) => const ChooseReturnTimeScreen(),
          '/confirm': (context) => const ConfirmDetailsScreen(),
          '/success': (context) => const ConfirmationSuccessScreen(),
          //'/students': (context) => const StudentList(),
          // '/supervisors': (context) => const SupervisorsScreen(),
          '/addAdmin': (context) => const AddAdmin(),
          '/addSupervisor': (context) => const AddSupervisor(),
        },
      ),
    );
  }
}
