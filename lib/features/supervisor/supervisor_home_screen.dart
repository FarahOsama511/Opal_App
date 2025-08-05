import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_state.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';
import '../../core/network/local_network.dart' show CacheNetwork;
import '../../core/resources/text_styles.dart';
import '../Admin/presentaion/widgets/app_header.dart';
import '../Admin/presentaion/widgets/expandable_card.dart';

class SupervisorScreen extends StatefulWidget {
  TourModel tour;
  SupervisorScreen({super.key, required this.tour});
  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  List<bool>? expandedList;
  // bool _inInit = true;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_inInit) {
  //     BlocProvider.of<GetAllUserCubit>(
  //       context,
  //     ).getUserById(widget.superVisorId);
  //     BlocProvider.of<GetTourIdCubit>(context).getTourById(widget.tourId);
  //     _inInit = false;
  //   }
  // }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTourIdCubit>(context).getTourById(widget.tour.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 210,
              top: -50,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset('assets/logos.png', width: 300, height: 300),
              ),
            ),
            Column(
              children: [
                AppHeader(
                  onLogout: () {
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  leadingWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<GetAllUserCubit, UserState>(
                        builder: (context, state) {
                          String lineName = '...';
                          if (state is UserByIdSuccess) {
                            print('LINEName:${state.userById.line!.name}');
                            lineName = state.userById.line?.name ?? 'غير معروف';
                          } else if (state is UserError) {
                            lineName = 'خط غير متاح';
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '!مرحباً ${CacheNetwork.getCacheData(key: "Save_UserName")}',
                                style: TextStyles.black20Bold.copyWith(
                                  fontSize: 20.sp,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'مشرف الخط - $lineName',
                                style: TextStyles.black20Bold.copyWith(
                                  fontSize: 20.sp,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  titleWidget: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        IconButton(
                          icon: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: Icon(Icons.logout, size: 24.sp),
                          ),
                          onPressed: () async {
                            await CacheNetwork.deleteCacheData(
                              key: 'access_token',
                            );
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFE71A45),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<GetTourIdCubit, GetTourIdState>(
                        builder: (context, state) {
                          if (state is TourByIdLoaded) {
                            final users = state.tour.users ?? [];
                            if (expandedList == null ||
                                expandedList!.length != users.length) {
                              expandedList = List.generate(
                                users.length,
                                (_) => false,
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'عدد الطلاب:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${users.length}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return ExpandableCard(
                                        name: user.name ?? '',
                                        phone: user.phone ?? '',
                                        university: user.university?.name ?? '',

                                        isSupervisor: false,
                                        isExpanded: expandedList![index],
                                        onToggle: () {
                                          setState(() {
                                            expandedList![index] =
                                                !expandedList![index];
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else if (state is GetTourByIdLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.secondColor,
                              ),
                            );
                          } else if (state is getTourByIdError) {
                            return const Center(
                              child: Text(
                                'فشل تحميل البيانات',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
