import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../Admin/presentaion/pages/trip_details.dart';
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

  @override
  void initState() {
    super.initState();
    isTripConfirmed = widget.isTripConfirmed;
    BlocProvider.of<TourCubit>(context).getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 210.w,
              top: -75.h,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/logos.png',
                  width: 330.w,
                  height: 330.h,
                ),
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
                          Text(
                            'مرحباً ${CacheNetwork.getCacheData(key: 'Save_UserName')}!',
                            style: TextStyles.black20Bold.copyWith(
                              fontSize: 20.sp,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'متى تريد الذهاب؟',
                            style: TextStyles.black20Bold.copyWith(
                              fontSize: 20.sp,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                  titleWidget: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                SizedBox(height: 12.h),

                if (isTripConfirmed)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailsScreen(
                            tour: context
                                .read<SelectionTourCubit>()
                                .tourCurrent!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: ColorManager.blackColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عرض الرحلة الخاصة بك',
                            style: TextStyles.black14Bold,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 18.sp),
                        ],
                      ),
                    ),
                  )
                else
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
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
                        _buildDepartureTimeSection(),
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
            return Center(child: CircularProgressIndicator());
          } else if (state is TourLoaded) {
            List<Tour> tours = state.tours;
            List<Tour> openTours = tours
                .where((tour) => tour.isBookingOpen)
                .toList();
            departureTimes = openTours
                .map((tour) => DateFormat('HH:mm').format(tour.leavesAt))
                .toSet()
                .toList();

            filteredTours = openTours
                .where(
                  (tour) =>
                      DateFormat('HH:mm').format(tour.leavesAt) == selectedTime,
                )
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: CustomDropdown(
                    label: 'اختيار الميعاد',
                    value: selectedTime,
                    items: departureTimes,
                    onChanged: (newValue) {
                      setState(() {
                        selectedTime = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                Container(
                  width: double.infinity,
                  child: CustomDropdown(
                    label: selectedTab == 0 ? 'اختيار الخط' : 'اختيار الجامعة',
                    value: selectedTab == 0
                        ? selectedLine?.name
                        : selectedUniversity?.name,
                    items: selectedTab == 0
                        ? filteredTours
                              .map((tour) => tour.line.name)
                              .toSet()
                              .toList()
                        : filteredTours
                              .map((tour) => tour.driverName)
                              .toSet()
                              .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        if (selectedTab == 0) {
                          selectedTour = filteredTours.firstWhere(
                            (tour) => tour.line.name == newValue,
                          );
                          selectedLine = LineEntity(
                            name: selectedTour!.line.name,
                            notes: selectedTour!.line.notes,
                          );
                        } else {
                          final selectedTour = filteredTours.firstWhere(
                            (tour) => tour.driverName == newValue,
                          );
                          // selectedUniversity = UniversityEntity(
                          //   name: selectedTour.university.name,
                          //   notes: selectedTour.university.notes,
                          // );
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                if (selectedLine != null || selectedUniversity != null)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Column(
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
                              builder: (_) =>
                                  ConfirmDetailsScreen(tour: selectedTour!),
                            );
                            if (confirmed == true) {
                              setState(() {
                                isTripConfirmed = true;
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
              onPressed: () {
                setState(() {
                  selectedTab = 0;
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
              onPressed: () {
                setState(() {
                  selectedTab = 1;
                  departureTimes = [];
                  filteredTours = [];
                  selectedTime = null;
                  selectedLine = null;
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
