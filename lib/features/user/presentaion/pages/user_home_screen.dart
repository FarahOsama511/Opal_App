import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/app_header.dart'
    show AppHeader;
import 'package:opal_app/features/selection/presentation/pages/confirm_details.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../../Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../../../Admin/presentaion/pages/trip_details.dart';
import '../../../Admin/presentaion/widgets/bus_card.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';

class UserHomeScreen extends StatefulWidget {
  final bool isTripConfirmed;
  const UserHomeScreen({super.key, this.isTripConfirmed = false});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int? expandedCardIndex;
  LineEntity? selectedLine;
  late bool isTripConfirmed;

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
                  BlocBuilder<LinesCubit, GetAllLinesState>(
                    builder: (context, state) {
                      if (state is LinesLoading) {
                        return const CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        );
                      } else if (state is LinesLoaded) {
                        return CustomDropdown(
                          label: 'اختر الخط الخاص بك',
                          value: selectedLine,
                          items: state.Liness,
                          onChanged: (value) {
                            setState(() => selectedLine = value);
                          },
                          displayString: (u) => u.name!,
                        );
                      } else {
                        return Text(
                          'فشل في تحميل الخطوط',
                          style: TextStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 14.sp,
                          ),
                        );
                      }
                    },
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'مواعيد الذهاب _ العودة',
                            style: TextStyles.white20Bold,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        BlocBuilder<TourCubit, TourState>(
                          builder: (context, state) {
                            if (state is TourLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.secondColor,
                                ),
                              );
                            } else if (state is TourLoaded) {
                              final tours = selectedLine == null
                                  ? state.tours
                                  : state.tours
                                        .where(
                                          (t) =>
                                              t.line.name == selectedLine!.name,
                                        )
                                        .toList();

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: tours.length,
                                  itemBuilder: (context, index) {
                                    final isExpanded =
                                        index == expandedCardIndex;
                                    return BusCard(
                                      isExpanded: isExpanded,
                                      onTap: isTripConfirmed
                                          ? null
                                          : () async {
                                              setState(() {
                                                expandedCardIndex = isExpanded
                                                    ? null
                                                    : index;
                                              });

                                              final confirmed =
                                                  await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) =>
                                                        ConfirmDetailsScreen(
                                                          tourId:
                                                              tours[index].id!,
                                                        ),
                                                  );

                                              if (confirmed == true) {
                                                setState(() {
                                                  isTripConfirmed = true;
                                                });
                                              }
                                            },
                                      typeOfTrip: tours[index].typeDisplay,
                                      line: tours[index].line.name ?? "",
                                      supervisorName:
                                          tours[index].driverName ?? "غير معرف",
                                      departureTime: DateFormat(
                                        'HH:mm',
                                      ).format(tours[index].leavesAt),
                                      date: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(tours[index].leavesAt),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  'حدث خطأ أثناء تحميل الرحلات',
                                  style: TextStyles.white20Bold,
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
