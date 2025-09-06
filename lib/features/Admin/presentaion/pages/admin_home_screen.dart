import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/create_admin_supervisors/add_admin_supervisor_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/pages/settings.dart';
import 'package:opal_app/features/Admin/presentaion/pages/student_list.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trips.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/get_it.dart' as di;
import '../../../../core/resources/text_styles.dart';
import '../bloc/delete_user/delete_user_cubit.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../widgets/add_menu.dart';
import '../widgets/app_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/join_request_card.dart';
import 'add_trip_time.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool showAddMenu = false;
  int currentIndex = 0;
  bool showAddTripBox = false;
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// ===== الهيدر الأبيض =====
                Container(
                  height: 80.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      /// اللوجو الباهت نصه باين
                      Positioned(
                        top: -60.h,
                        right: -100.w,
                        child: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            'assets/logos.png',
                            width: 220.w,
                            height: 220.h,
                          ),
                        ),
                      ),

                      /// الأزرار (AppHeader)
                      AppHeader(
                        isAdmin: true,
                        onLogout: () async {
                          await CacheNetwork.deleteCacheData(
                            key: 'access_token',
                          );
                          context.go('/signin');
                        },
                        showAddButton: true,
                        onAddPressed: () =>
                            setState(() => showAddMenu = !showAddMenu),
                      ),
                    ],
                  ),
                ),

                /// ===== محتوى الشاشة (الـ IndexedStack) =====
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: currentIndex,
                        children: [
                          _buildJoinRequests(),
                          BlocProvider(
                            create: (_) => di.setUp<TourCubit>()
                              ..getAllTours(), // تأكد من استدعاء getAllTours هنا
                            child: const TripsScreen(),
                          ),
                          MultiBlocProvider(
                            providers: [
                              BlocProvider<DeleteUserCubit>(
                                create: (_) => di.setUp<DeleteUserCubit>(),
                              ),
                              BlocProvider<AddAdminSupervisorCubit>(
                                create: (_) =>
                                    di.setUp<AddAdminSupervisorCubit>(),
                              ),
                            ],

                            child: const StudentList(),
                          ),
                          const SettingsScreen(),
                        ],
                      ),

                      /// ===== البوتوم بار =====
                      CustomBottomNav(
                        currentIndex: currentIndex,
                        onTap: (index) => setState(() => currentIndex = index),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// ===== منيو الإضافة =====
            if (showAddMenu)
              AddMenu(
                onAddTrip: () {
                  setState(() {
                    showAddTripBox = true;
                    showAddMenu = false;
                  });
                },
              ),

            /// ===== Add Trip Box =====
            if (showAddTripBox)
              Positioned(
                top: 150.h,
                left: 20.w,
                right: 20.w,
                child: AddTripBox(
                  onClose: () => setState(() => showAddTripBox = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinRequests() {
    return Container(
      width: double.infinity,
      color: ColorManager.primaryColor,
      padding: EdgeInsets.only(top: 12.h, bottom: 90.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w, bottom: 12.h),
              child: Text('طلبات الانضمام', style: TextStyles.white20Bold),
            ),
          ),
          Expanded(
            child: BlocConsumer<GetAllUserCubit, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                print("Current state: $state");

                if (state is UserSuccess) {
                  final unactivatedUsers = state.user
                      .where((u) => u.status == 'pending')
                      .toList();
                  if (unactivatedUsers.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد طلبات انضمام حاليا",
                        style: TextStyle(color: Colors.white, fontSize: 25.sp),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    itemCount: unactivatedUsers.length,
                    itemBuilder: (context, index) {
                      final data = unactivatedUsers[index];
                      return JoinRequestCard(
                        name: data.name!,
                        phone: data.phone!,
                        university: data.university?.name ?? "",
                        downTown: data.downTown?.name ?? "",
                        isExpanded: expandedIndex == index,
                        onToggle: () {
                          setState(() {
                            expandedIndex = expandedIndex == index
                                ? null
                                : index;
                          });
                        },
                        onAccept: () async {
                          await context.read<GetAllUserCubit>().userIsActivate(
                            data.id!,
                          );
                        },
                        onReject: () async {
                          await context
                              .read<GetAllUserCubit>()
                              .userIsDeactivate(data.id!);
                        },
                      );
                    },
                  );
                } else if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else {
                  return const Center(child: Text("ERROR"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
