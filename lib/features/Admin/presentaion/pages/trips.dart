import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/get_tour_bloc/tour_state.dart';
import '../bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import '../widgets/bus_card.dart';
import '../widgets/trip_dialog.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int? expandedIndex;
  void _showTripOptionsDialog(BuildContext context, String tourId) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<UpdateAddDeleteTourCubit>(),
        child: TripDetailsDialog(tourId: tourId),
      ),
    );
  }

  bool _inInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inInit) {
      BlocProvider.of<TourCubit>(context).getAllTours();
      _inInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("مواعيد الرحلات", style: TextStyles.white20Bold),
              ),
            ),
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
                child: BlocConsumer<TourCubit, TourState>(
                  listener: (context, state) {
                    if (state is TourError) {
                      print("error in trips:${state}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: TextStyle(color: ColorManager.secondColor),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is TourLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.secondColor,
                        ),
                      );
                    } else if (state is TourLoaded) {
                      if (state.tours.isEmpty) {
                        return Center(
                          child: Text(
                            "لا توجد رحلات حاليا",
                            style: TextStyles.white14Bold,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.tours.length,
                        itemBuilder: (context, index) {
                          String tourId = state.tours[index].id ?? "";
                          return BusCard(
                            line: 'خط ${state.tours[index].line.name}',
                            supervisorName: state.tours[index].driverName,
                            departureTime: DateFormat(
                              'yyyy-MM-dd',
                            ).format(state.tours[index].leavesAt),

                            date: DateFormat(
                              'HH:mm',
                            ).format(state.tours[index].leavesAt),
                            isExpanded: expandedIndex == index,
                            onTap: () =>
                                _showTripOptionsDialog(context, tourId),
                            onCancel: () =>
                                setState(() => expandedIndex = null),
                            onNext: () {},
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "حدث فشل في جلب البيانات",
                          style: TextStyles.white14Bold,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
