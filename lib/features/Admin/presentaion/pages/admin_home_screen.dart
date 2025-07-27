import 'package:flutter/material.dart';
import 'package:opal_app/features/Admin/presentaion/pages/student_list.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trips.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';
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
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUserCubit>(context).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  onLogout: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  showAddButton: true,
                  onAddPressed: () =>
                      setState(() => showAddMenu = !showAddMenu),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: currentIndex,
                        children: [
                          _buildJoinRequests(),
                          const TripsScreen(),
                          const StudentList(),
                        ],
                      ),
                      CustomBottomNav(
                        currentIndex: currentIndex,
                        onTap: (index) => setState(() => currentIndex = index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showAddMenu)
              AddMenu(
                onAddTrip: () {
                  setState(() {
                    showAddTripBox = true;
                    showAddMenu = false;
                  });
                },
              ),
            if (showAddTripBox)
              Positioned(
                top: 150,
                left: 20,
                right: 20,
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
      color: const Color(0xFFE71A45),
      padding: const EdgeInsets.only(top: 12, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16, bottom: 12),
              child: Text(
                'طلبات الانضمام',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<GetAllUserCubit, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  print("ERROR:${state.message}");
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is UserSuccess) {
                  print("length:${state.user.length}");
                  final unactivatedUsers = state.user
                      .where((u) => u.isActivated == false)
                      .toList();
                  if (unactivatedUsers.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد طلبات انضمام حاليا",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    );
                  }
                  print("KEWFB${unactivatedUsers}");
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: unactivatedUsers.length,
                    itemBuilder: (context, index) {
                      final data = unactivatedUsers[index];
                      return JoinRequestCard(
                        name: data.name!,
                        phone: data.phone!,
                        university: data.university?.name ?? "",
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
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else {
                  return Center(child: Text("ERROR"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
