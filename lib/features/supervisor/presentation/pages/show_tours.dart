import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/app_header.dart'
    show AppHeader;
import 'package:opal_app/features/Admin/presentaion/widgets/expandable_card.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/text_styles.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../../../Admin/presentaion/widgets/search_field.dart';
import '../../../Admin/presentaion/widgets/trip_type_selector.dart';
import '../../../user/presentaion/bloc/user_cubit.dart';
import '../../../user/presentaion/bloc/user_state.dart';

class ShowToursBySuperVisor extends StatefulWidget {
  final bool? isTripConfirmed;

  const ShowToursBySuperVisor({super.key, this.isTripConfirmed = false});

  @override
  State<ShowToursBySuperVisor> createState() => _ShowToursBySuperVisorState();
}

class _ShowToursBySuperVisorState extends State<ShowToursBySuperVisor> {
  UserEntity? user;
  String lineName = "";
  late bool isTripConfirmed;

  // التحكم في التوسيع
  List<bool> _isExpandedStudents = [];

  // البيانات
  List<UserEntity> _users = [];
  List<UserEntity> _filteredUsers = [];
  String _searchQuery = '';

  // نوع الرحلة (0 ذهاب، 1 عودة)
  int _selectedTripType = 0;

  final userId = CacheNetwork.getCacheData(key: "Save_UserId");

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
    BlocProvider.of<GetAllUserCubit>(context).getUserById(userId);
  }

  void _updateFilteredUsers() {
    _filteredUsers = _users;
    if (_searchQuery.isNotEmpty) {
      _filteredUsers = _filteredUsers.where((u) {
        return u.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            u.id!.contains(_searchQuery) ||
            u.phone!.contains(_searchQuery) ||
            (u.university?.name?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }

    if (_isExpandedStudents.length != _filteredUsers.length) {
      _isExpandedStudents = List.generate(_filteredUsers.length, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 220,
              top: -50,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/logos.png', width: 300, height: 300),
              ),
            ),
            Column(
              children: [
                AppHeader(
                  onLogout: () async {
                    await CacheNetwork.deleteCacheData(key: 'access_token');
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  leadingWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocBuilder<GetAllUserCubit, UserState>(
                            builder: (context, state) {
                              if (state is UserByIdSuccess) {
                                user = state.userById;
                                lineName =
                                    state.userById.line?.name ?? 'غير معروف';
                              } else if (state is UserError) {
                                lineName = 'خط غير متاح';
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'مرحباً ${CacheNetwork.getCacheData(key: "Save_UserName")}!',
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
                    ],
                  ),
                  titleWidget: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: Icon(
                          Icons.logout,
                          size: 30.sp,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () async {
                        await CacheNetwork.deleteCacheData(key: 'access_token');
                        context.go('/signin');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SearchField(
                              hintText: 'ابحث عن مستخدم',
                              fillColor: Colors.white,
                              iconColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _updateFilteredUsers();
                                });
                              },
                            ),
                            SizedBox(height: 12.h),
                            TripTypeSelector(
                              selectedIndex: _selectedTripType,
                              onChanged: (index) {
                                setState(() {
                                  _selectedTripType = index;
                                });
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'عدد الطلاب',
                            style: TextStyles.white20Bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        BlocBuilder<TourCubit, TourState>(
                          builder: (context, state) {
                            if (state is TourLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.secondColor,
                                ),
                              );
                            } else if (state is TourError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: TextStyles.white20Bold,
                                ),
                              );
                            } else if (state is TourLoaded) {
                              final tours = state.tours
                                  .where(
                                    (tour) =>
                                        tour.line.id != null &&
                                        user?.line?.id == tour.line.id,
                                  )
                                  .toList();

                              // حسب نوع الرحلة
                              List<UserEntity> allUsers = [];
                              if (_selectedTripType == 0) {
                                // رحلات الذهاب: الطلاب المرتبطين بالخط
                                final studentInTours = tours
                                    .where(
                                      (tour) => tour.users?.isNotEmpty ?? false,
                                    )
                                    .toList();
                                allUsers = studentInTours
                                    .expand((tour) => tour.users ?? [])
                                    .whereType<UserEntity>()
                                    .toList();
                              } else {
                                // رحلات العودة: الطلاب المرتبطين بالجامعات
                                final allowedUniversities =
                                    user?.universitiesId ?? [];
                                final studentInTours = tours
                                    .where(
                                      (tour) => tour.users?.isNotEmpty ?? false,
                                    )
                                    .toList();
                                allUsers = studentInTours
                                    .expand((tour) => tour.users ?? [])
                                    .whereType<UserEntity>()
                                    .where(
                                      (u) => allowedUniversities.contains(
                                        u.university?.id,
                                      ),
                                    )
                                    .toList();
                              }

                              _users = allUsers;
                              _updateFilteredUsers();

                              if (_filteredUsers.isEmpty) {
                                return Center(
                                  child: Text(
                                    'لا يوجد طلاب مرتبطين بهذه الرحلات',
                                    style: TextStyles.white20Bold,
                                  ),
                                );
                              } else {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: _filteredUsers.length,
                                    itemBuilder: (context, index) {
                                      final student = _filteredUsers[index];
                                      return ExpandableCard(
                                        name: student.name ?? 'غير معروف',
                                        phone: student.phone ?? "",
                                        university: student.university,
                                        isSupervisor: false,
                                        isExpanded: _isExpandedStudents[index],
                                        onToggle: () {
                                          setState(() {
                                            _isExpandedStudents[index] =
                                                !_isExpandedStudents[index];
                                          });
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.primaryColor,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
