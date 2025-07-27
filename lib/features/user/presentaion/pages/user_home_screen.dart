import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/theming/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
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
                  SizedBox(width: 10.w),
                  const Icon(Icons.person),
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
                      builder: (_) => const TripDetailsScreen(),
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
                    color: ColorManager.greyColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorManager.greyColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عرض الرحلة الخاصة بك',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18.r),
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
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.secondColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    BlocBuilder<TourCubit, TourState>(
                      builder: (context, state) {
                        if (state is TourLoaded) {
                          final getTourByLineId = selectedLine == null
                              ? state.tours
                              : state.tours
                                    .where((u) => u.line.id == selectedLine)
                                    .toList();

                          return Expanded(
                            child: ListView.builder(
                              itemCount: getTourByLineId.length,
                              itemBuilder: (context, index) {
                                final isExpanded = index == expandedCardIndex;

                                return BusCard(
                                  isExpanded: isExpanded,
                                  onTap: () {
                                    setState(() {
                                      expandedCardIndex = isExpanded
                                          ? null
                                          : index;
                                    });
                                  },
                                  onCancel: () {
                                    setState(() {
                                      expandedCardIndex = null;
                                    });
                                  },
                                  onNext: () {
                                    Navigator.pushNamed(context, '/confirm');
                                  },
                                  line:
                                      'خط ${getTourByLineId[index].line.name}',
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
                          return const Center(
                            child: CircularProgressIndicator(),
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
