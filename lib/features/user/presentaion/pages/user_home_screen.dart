import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/selection/presentation/pages/confirm_details.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../../Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../../../Admin/presentaion/pages/trip_details.dart';
import '../../../Admin/presentaion/widgets/app_header.dart';
import '../../../Admin/presentaion/widgets/bus_card.dart';

class UserHomeScreen extends StatefulWidget {
  final bool isTripConfirmed;
  const UserHomeScreen({super.key, this.isTripConfirmed = false});
  @override
  State<UserHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserHomeScreen> {
  int? expandedCardIndex;
  LineEntity? selectedLine;
  List<LineEntity> allLines = [];
  late bool isTripConfirmed;
  String? TripConfirmedId;
  @override
  void initState() {
    super.initState();
    isTripConfirmed = widget.isTripConfirmed;
    BlocProvider.of<TourCubit>(context).getAllTours();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              onLogout: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              leadingWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                  ),
                ],
              ),
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '!مرحبا${context.read<AuthCubit>().user!.user.name}',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'متى تريد الذهاب؟',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              trailingWidget: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/logo.png',
                  width: 60.w,
                  height: 60.h,
                ),
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            SizedBox(height: 12.h),
            if (isTripConfirmed)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripDetailsScreen(
                        tourId: context
                            .read<SelectionTourCubit>()
                            .TourConfirmedId!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.secondColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorManager.blackColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عرض الرحلة الخاصة بك',
                        style: TextStyles.black16Regular,
                      ),
                    ],
                  ),
                ),
              )
            else
              BlocBuilder<LinesCubit, GetAllLinesState>(
                builder: (context, state) {
                  print("state is${state}");
                  if (state is LinesLoading) {
                    return const CircularProgressIndicator(
                      color: ColorManager.primaryColor,
                    );
                  } else if (state is LinesLoaded) {
                    final allLines = state.Liness;
                    print("${state.Liness.length}");
                    return CustomDropdown(
                      label: 'اختر الخط الخاص بك',
                      value: selectedLine,
                      items: allLines,
                      onChanged: (value) {
                        setState(() => selectedLine = value);
                      },
                      displayString: (u) => u.name!,
                    );
                  } else {
                    return const Text('فشل في تحميل الخطوط');
                  }
                },
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'مواعبد الذهاب _ العودة',
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
                          final getTourByLineId = selectedLine == null
                              ? state.tours
                              : state.tours
                                    .where(
                                      (u) => u.line.name == selectedLine!.name,
                                    )
                                    .toList();

                          return Expanded(
                            child: ListView.builder(
                              itemCount: getTourByLineId.length,
                              itemBuilder: (context, index) {
                                final isExpanded = index == expandedCardIndex;
                                return BusCard(
                                  isExpanded: isExpanded,
                                  onTap: (isTripConfirmed)
                                      ? null
                                      : () {
                                          setState(() {
                                            expandedCardIndex = isExpanded
                                                ? null
                                                : index;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ConfirmDetailsScreen(
                                                    tourId:
                                                        getTourByLineId[index]
                                                            .id!,
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                        },

                                  line: ' ${getTourByLineId[index].line.name}',
                                  supervisorName:
                                      getTourByLineId[index].driverName,
                                  departureTime: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(getTourByLineId[index].leavesAt),
                                  date: DateFormat(
                                    'HH:mm',
                                  ).format(getTourByLineId[index].leavesAt),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'حدث خطأ أثناء تحميل الرحلات',
                              style: TextStyles.white14Bold,
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
      ),
    );
  }
}
