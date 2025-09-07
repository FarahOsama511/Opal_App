import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/get_it.dart' as di;
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_university/add_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/create_admin_supervisors/add_admin_supervisor_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_user/delete_user_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/pages/add_down_town.dart';
import 'package:opal_app/features/Admin/presentaion/pages/add_line.dart';
import 'package:opal_app/features/Admin/presentaion/pages/add_university.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trip_details.dart';
import 'package:opal_app/features/supervisor/presentation/pages/show_tours.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import 'package:opal_app/features/user/presentaion/pages/sign_in.dart';
import 'package:opal_app/features/user/presentaion/pages/sign_up.dart';
import 'package:opal_app/splashscreen.dart';
import 'features/Admin/Domain/entities/tour.dart';
import 'features/Admin/presentaion/bloc/add_down_town/add_down_town_cubit.dart';
import 'features/Admin/presentaion/bloc/delete_down_town/delete_down_town_cubit.dart';
import 'features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'features/Admin/presentaion/pages/add_admin.dart';
import 'features/Admin/presentaion/pages/add_supervisor.dart';
import 'features/Admin/presentaion/pages/admin_home_screen.dart';
import 'features/Admin/presentaion/pages/trips.dart';
import 'features/selection/presentation/pages/confirm_details.dart';
import 'features/selection/presentation/pages/confirmation_success.dart';
import 'features/user/presentaion/bloc/auth_cubit.dart';
import 'features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import 'features/user/presentaion/pages/user_home_screen.dart';
import 'features/user/presentaion/pages/waiting_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DeciderPage()),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.setUp<AuthCubit>()),
              BlocProvider(
                create: (_) =>
                    di.setUp<GetAllUniversitiesCubit>()..fetchAlluniversities(),
              ),
              BlocProvider(
                create: (_) => di.setUp<LinesCubit>()..getAllLiness(),
              ),
              BlocProvider(
                create: (_) =>
                    di.setUp<GetAllDownTownCubit>()..fetchAllDownTowns(),
              ),
            ],

            child: const SignUpScreen(),
          );
        },
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) {
          return BlocProvider.value(
            value: di.setUp<AuthCubit>(),
            child: const SignInScreen(),
          );
        },
      ),
      GoRoute(
        path: '/waiting',
        builder: (context, state) => const WaitingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return UserHomeScreen();
        },
      ),
      GoRoute(
        path: '/ConfirmDetailsScreen',
        builder: (context, state) {
          final tour = state.extra as Tour;
          return BlocProvider(
            create: (_) => di.setUp<SelectionTourCubit>(),
            child: ConfirmDetailsScreen(tour: tour),
          );
        },
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) => ConfirmationSuccessScreen(),
      ),

      // GoRoute(
      //   path: '/students',
      //   builder: (context, state) {
      //     return MultiBlocProvider(
      //       providers: [],
      //       child: Builder(
      //         builder: (context) {
      //           return const StudentList();
      //         },
      //       ),
      //     );
      //   },
      // ),
      GoRoute(
        path: '/adminScreen',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              //BlocProvider(create: (_) => di.setUp<TourCubit>()..getAllTours()),
              BlocProvider(create: (_) => di.setUp<DeleteUserCubit>()),
              BlocProvider(create: (_) => di.setUp<AddAdminSupervisorCubit>()),
              // BlocProvider(
              //   create: (_) => di.setUp<GetAllUserCubit>()..fetchAllUsers(),
              // ),
              BlocProvider(
                create: (_) =>
                    di.setUp<GetAllDownTownCubit>()..fetchAllDownTowns(),
              ),
              BlocProvider(
                create: (_) => di.setUp<LinesCubit>()..getAllLiness(),
              ),
              BlocProvider(
                create: (_) =>
                    di.setUp<GetAllUniversitiesCubit>()..fetchAlluniversities(),
              ),
              BlocProvider(create: (_) => di.setUp<DeleteUniversityCubit>()),
              BlocProvider(create: (_) => di.setUp<DeleteLineCubit>()),
              BlocProvider(create: (_) => di.setUp<DeleteDownTownCubit>()),
            ],
            child: Builder(
              builder: (context) {
                return const AdminHomeScreen();
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/supervisorScreen',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return ShowToursBySuperVisor(user: user);
        },
      ),
      GoRoute(
        path: '/addAdmin',
        builder: (context, state) {
          return BlocProvider<AddAdminSupervisorCubit>(
            create: (_) => di.setUp<AddAdminSupervisorCubit>(),
            child: Builder(builder: (context) => const AddAdmin()),
          );
        },
      ),
      GoRoute(
        path: '/addSupervisor',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.setUp<AddAdminSupervisorCubit>()),
              BlocProvider(
                create: (_) =>
                    di.setUp<GetAllUniversitiesCubit>()..fetchAlluniversities(),
              ),
              BlocProvider(
                create: (_) => di.setUp<LinesCubit>()..getAllLiness(),
              ),
            ],
            child: Builder(
              builder: (context) {
                return const AddSupervisor();
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/addLine',
        builder: (context, state) {
          return BlocProvider<AddLineCubit>(
            create: (_) => di.setUp<AddLineCubit>(),
            child: Builder(builder: (context) => const AddLine()),
          );
        },
      ),
      GoRoute(
        path: '/addUniversity',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AddUniversityCubit>(
                create: (_) => di.setUp<AddUniversityCubit>(),
              ),
              BlocProvider(create: (_) => di.setUp<GetAllUniversitiesCubit>()),
            ],
            child: Builder(builder: (context) => const AddUniversity()),
          );
        },
      ),
      GoRoute(
        path: '/addDownTown',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AddDownTownCubit>(
                create: (_) => di.setUp<AddDownTownCubit>(),
              ),
              BlocProvider(create: (_) => di.setUp<GetAllDownTownCubit>()),
            ],
            child: Builder(builder: (context) => const AddDownTown()),
          );
        },
      ),
      GoRoute(
        path: '/trips',
        builder: (context, state) {
          return BlocProvider<TourCubit>(
            create: (_) => di.setUp<TourCubit>(),
            child: Builder(
              builder: (context) {
                return TripsScreen();
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/tripDetails',
        builder: (context, state) {
          final tour = state.extra as TourModel;
          return TripDetailsScreen(tour: tour);
        },
      ),
    ],
  );
}
