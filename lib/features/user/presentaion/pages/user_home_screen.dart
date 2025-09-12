import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';
import 'package:opal_app/features/selection/presentation/pages/confirm_details.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/line_entity.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../../../Admin/presentaion/widgets/app_header.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../bloc/selection_tour/selection_tour_cubit.dart';

class UserHomeScreen extends StatefulWidget {
  final bool isTripConfirmed;
  const UserHomeScreen({super.key, this.isTripConfirmed = false});
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int? expandedCardIndex;
  LineEntity? selectedLine;
  UniversityEntity? selectedUniversity;
  late bool isTripConfirmed;
  Tour? selectedTour;
  int selectedTab = 0;
  String? selectedTime;
  List<String> departureTimes = [];
  List<Tour> filteredTours = [];
  TextEditingController notesController = TextEditingController();
  Timer? tripTimer;
  String? lastTripType; // go أو return
  Future<void> _saveSelectedTrip(Tour tour) async {
    await CacheNetwork.insertToCache(
      key: "selected_tour_id",
      value: tour.id ?? "",
    );
    await CacheNetwork.insertToCache(
      key: "selected_trip_type",
      value: tour.type,
    );
    await CacheNetwork.insertToCache(
      key: "selected_leaves_at",
      value: tour.leavesAt.toIso8601String(),
    );
    print("tour is ==$selectedTour");
  }

  Future<void> _loadSelectedTrip() async {
    final tourId = CacheNetwork.getCacheData(key: "selected_tour_id");
    final tripType = CacheNetwork.getCacheData(key: "selected_trip_type");
    final leavesAtStr = CacheNetwork.getCacheData(key: "selected_leaves_at");
    if (tourId != null && leavesAtStr != null) {
      final leavesAt = DateTime.parse(leavesAtStr);
      final now = DateTime.now();
      if (now.isBefore(leavesAt)) {
        // استدعاء الرحلة من الـ API
        await context.read<SelectionTourCubit>().selectionTour(tourId);
        final tour = context.read<SelectionTourCubit>().tourCurrent;
        if (tour != null) {
          setState(() {
            isTripConfirmed = true;
            lastTripType = tripType;
            selectedTab = (tripType == "go") ? 0 : 1;
            selectedTour = tour;
          });
        }
        //  else {
        //   // لو الرحلة مش اتحملت لأي سبب
        //   await CacheNetwork.deleteCacheData(key: "selected_tour_id");
        //   await CacheNetwork.deleteCacheData(key: "selected_trip_type");
        //   await CacheNetwork.deleteCacheData(key: "selected_leaves_at");
        // }
      } else {
        // لو ميعاد الرحلة خلص
        await CacheNetwork.deleteCacheData(key: "selected_tour_id");
        await CacheNetwork.deleteCacheData(key: "selected_trip_type");
        await CacheNetwork.deleteCacheData(key: "selected_leaves_at");
      }
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
    isTripConfirmed = widget.isTripConfirmed;
    _initData();
    tripTimer = Timer.periodic(Duration(minutes: 1), (_) {
      _checkTripTime();
    });
  }

  Future<void> _initData() async {
    await _loadSelectedTrip();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    tripTimer?.cancel();
    super.dispose();
  }

  void _checkTripTime() {
    if (selectedTour != null && isTripConfirmed) {
      final now = DateTime.now();
      if (now.isAfter(selectedTour!.leavesAt)) {
        setState(() {
          isTripConfirmed = false;
          selectedTour = null;
          selectedLine = null;
          selectedTime = null;

          selectedTab = lastTripType == 'go' ? 1 : 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
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
                AppHeader(
                  onLogout: () async {
                    await CacheNetwork.deleteCacheData(key: 'access_token');
                    context.go('/signin');
                  },
                  leadingWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'مرحباً ${CacheNetwork.getCacheData(key: 'Save_UserName')}!',
                        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'متى تريد ${selectedTab == 0 ? "الذهاب" : "العودة"}؟',
                        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
                        textAlign: TextAlign.right,
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
              ],
            ),
            SizedBox(height: 12.h),
            Column(
              children: [
                SizedBox(height: 12.h),
                _buildSwitchButtons(),
              ],
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 15.h),
                    if (isTripConfirmed &&
                        ((selectedTab == 0 && lastTripType == 'go') ||
                            (selectedTab == 1 && lastTripType == 'return')) &&
                        selectedTour != null)
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.secondColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 14.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: () {
                            print(
                              'selectedTour: ${context.read<SelectionTourCubit>().tourCurrent!}',
                            );
                            context.push(
                              '/tripDetails',
                              extra: selectedTour,
                              //  context
                              //     .read<SelectionTourCubit>()
                              //     .tourCurrent!,
                            );
                          },
                          child: Text(
                            "عرض تفاصيل الرحلة",
                            style: TextStyles.black14Bold,
                          ),
                        ),
                      )
                    else
                      _buildDepartureTimeSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الجزء الخاص باختيار الميعاد والخط
  Widget _buildDepartureTimeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorManager.secondColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.blackColor),
      ),
      child: BlocBuilder<TourCubit, TourState>(
        builder: (context, state) {
          if (state is TourLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorManager.primaryColor,
              ),
            );
          } else if (state is TourLoaded) {
            print('عدد الرحلات المستلمة: ${state.tours.length}');

            List<Tour> tours = state.tours
                .where(
                  (tour) => selectedTab == 0
                      ? tour.type == 'go'
                      : tour.type == 'return',
                )
                .toList();

            List<Tour> openTours = tours
                .where((tour) => tour.isBookingOpen)
                .toList();
            print('openTours: $openTours');

            departureTimes = openTours
                .map((tour) => DateFormat('HH:mm').format(tour.leavesAt))
                .toSet()
                .toList();
            print('departureTimes: $departureTimes');

            filteredTours = openTours
                .where(
                  (tour) =>
                      DateFormat('HH:mm').format(tour.leavesAt) == selectedTime,
                )
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown(
                  label: 'اختيار الميعاد',
                  value: selectedTime,
                  items: departureTimes,
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue;
                    });
                  },
                ),
                SizedBox(height: 12.h),

                CustomDropdown(
                  label: selectedTab == 0 ? 'اختيار الخط' : 'اختيار الخط',
                  value: selectedLine?.name,
                  items: filteredTours
                      .map((tour) => tour.line.name)
                      .toSet()
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTour = filteredTours.firstWhere(
                        (tour) => tour.line.name == newValue,
                      );
                      selectedLine = LineEntity(
                        name: selectedTour!.line.name,
                        notes: selectedTour!.line.notes,
                      );
                    });
                  },
                ),
                SizedBox(height: 12.h),

                if (selectedLine != null)
                  Column(
                    children: [
                      Text(
                        selectedLine?.notes ?? ".....",
                        style: TextStyles.black14Bold,
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => Builder(
                              builder: (_) =>
                                  ConfirmDetailsScreen(tour: selectedTour!),
                            ),
                          );
                          print('تم الدخول للدالة');
                          print('قيمة confirmed: $confirmed');
                          if (confirmed == true) {
                            setState(() {
                              _saveSelectedTrip(selectedTour!);
                              isTripConfirmed = true;
                              lastTripType = selectedTour!.type;
                              print('isTripConfirmed: $isTripConfirmed');
                              print('lastTripType: $lastTripType');
                              print('selectedTab: $selectedTab');

                              // go أو return
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE71A45),
                        ),
                        child: Center(
                          child: Text(
                            "تأكيد الرحلة",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          } else if (state is TourError) {
            return Center(child: Text('خطأ في تحميل البيانات'));
          }
          return Container();
        },
      ),
    );
  }

  /// دالة الأزرار
  Widget _buildSwitchButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: (lastTripType == 'go' && !isTripConfirmed)
                  ? null
                  : () {
                      setState(() {
                        selectedTab = 0;
                        selectedLine = null;
                        selectedTime = null;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTab == 0
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'مواعيد الذهاب',
                style: TextStyle(
                  color: selectedTab == 0 ? Colors.white : Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: (lastTripType == 'return' && !isTripConfirmed)
                  ? null
                  : () {
                      setState(() {
                        selectedTab = 1;
                        selectedLine = null;
                        selectedTime = null;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTab == 1
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'مواعيد العودة',
                style: TextStyle(
                  color: selectedTab == 1 ? Colors.white : Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
