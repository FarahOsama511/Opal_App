import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/get_tour_bloc/tour_state.dart';

import '../widgets/bus_card.dart';
import '../widgets/search_field.dart';
import '../widgets/trip_dialog.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int? expandedIndex;
  void _showTripOptionsDialog(BuildContext context, String tourId, Tour tour) {
    showDialog(
      context: context,
      builder: (_) => TripDetailsDialog(tourId: tourId, selectedtour: tour),
    );
  }

  List<Tour> _tours = [];
  List<Tour> _filteredTours = [];
  void _updateFilteredTours(String searchQuery) {
    _filteredTours = _tours;
    if (searchQuery.isNotEmpty) {
      _filteredTours = _tours.where((tour) {
        return tour.line.name!.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            tour.driverName!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
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
            SearchField(
              hintText: 'ابحث عن رحلة',
              fillColor: Colors.white,
              iconColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _updateFilteredTours(value);
                });
              },
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
                      _tours = state.tours;
                      _filteredTours = _tours;

                      if (_tours.isEmpty) {
                        return Center(
                          child: Text(
                            "لا توجد رحلات حاليا",
                            style: TextStyles.white14Bold,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: _filteredTours.length,
                        itemBuilder: (context, index) {
                          String tourId = _filteredTours[index].id ?? "";
                          final tour = _filteredTours[index];
                          return BusCard(
                            typeOfTrip: tour.typeDisplay,
                            line: 'خط ${tour.line.name}',
                            supervisorName: tour.driverName ?? "غير معرف",
                            departureTime: DateFormat(
                              'HH:mm',
                            ).format(tour.leavesAt),

                            date: DateFormat('yyy/MM/dd').format(tour.leavesAt),
                            isExpanded: expandedIndex == index,
                            onTap: () =>
                                _showTripOptionsDialog(context, tourId, tour),
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
