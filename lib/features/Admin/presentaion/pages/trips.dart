import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/get_tour_bloc/tour_state.dart';
import '../bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import '../bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
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
  List<Tour> _tours = [];
  List<Tour> _filteredTours = [];
  String _searchQuery = '';

  void _showTripOptionsDialog(BuildContext context, String tourId, Tour tour) {
    showDialog(
      context: context,
      builder: (_) => TripDetailsDialog(tourId: tourId, selectedtour: tour),
    );
  }

  void _updateFilteredTours(String searchQuery) {
    _searchQuery = searchQuery;
    if (searchQuery.isNotEmpty) {
      _filteredTours = _tours.where((tour) {
        return tour.line.name!.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            tour.driverName!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    } else {
      _filteredTours = _tours;
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
      listener: (context, state) {
        if (state is TourAdded ||
            state is TourUpdated ||
            state is TourDeleted) {
          BlocProvider.of<TourCubit>(context).getAllTours();
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "مواعيد الرحلات",
                    style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
                  ),
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
                  child: BlocConsumer<TourCubit, TourState>(
                    listener: (context, state) {
                      if (state is TourError) {
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
                        if (_searchQuery.isEmpty) _filteredTours = _tours;

                        if (_tours.isEmpty) {
                          return Center(
                            child: Text(
                              "لا توجد رحلات حاليا",
                              style: TextStyles.white14Bold.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: _filteredTours.length,
                          itemBuilder: (context, index) {
                            final tour = _filteredTours[index];
                            final tourId = tour.id ?? "";
                            return BusCard(
                              typeOfTrip: tour.typeDisplay,
                              line: 'خط ${tour.line.name}',
                              supervisorName:
                                  tour.supervisor.name ?? "غير معرف",
                              departureTime: DateFormat(
                                'HH:mm',
                              ).format(tour.leavesAt),
                              date: DateFormat(
                                'yyyy/MM/dd',
                              ).format(tour.leavesAt),
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
                            style: TextStyles.white14Bold.copyWith(
                              fontSize: 14.sp,
                            ),
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
      ),
    );
  }
}
