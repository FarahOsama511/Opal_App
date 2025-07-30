import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import 'package:opal_app/features/Admin/presentaion/pages/admin_home_screen.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../pages/edit_trip_time.dart';

class TripDetailsDialog extends StatefulWidget {
  final String tourId;
  final Tour selectedtour;
  const TripDetailsDialog({required this.tourId, required this.selectedtour});

  @override
  State<TripDetailsDialog> createState() => _TripDetailsDialogState();
}

class _TripDetailsDialogState extends State<TripDetailsDialog> {
  bool _inInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inInit) {
      BlocProvider.of<TourCubit>(context).getTourById(widget.tourId);
      _inInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(left: 2, top: 2, child: Image.asset('assets/logos.png')),
          Container(
            width: size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text('بيانات الرحلة', style: TextStyles.black20Bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: ColorManager.secondColor,
                  ),
                  child: BlocBuilder<TourCubit, TourState>(
                    builder: (context, state) {
                      if (state is TourLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryColor,
                          ),
                        );
                      } else if (state is TourByIdLoaded) {
                        final tour = state.tour;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRow('الخط', tour.line.name!),
                            _buildRow(
                              'ميعاد الذهاب',
                              '${DateFormat('HH:mm').format(tour.leavesAt)} صباحاً',
                            ),
                            _buildRow('اسم المشرف', tour.driverName),
                            _buildRow(
                              'تاريخ اليوم',
                              DateFormat('yyyy-MM-dd').format(tour.leavesAt),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            "حدث خطأ في جلب البيانات",
                            style: TextStyles.black14Bold,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: EditTripBox(
                          onClose: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AdminHomeScreen();
                              },
                            ),
                          ),
                          tour: widget.selectedtour,
                          tourId: widget.tourId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE71A45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text('تعديل الرحلة', style: TextStyles.white12Bold),
                ),

                const SizedBox(height: 12),

                BlocBuilder<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
                  builder: (context, state) {
                    print(" STATE${state}");
                    if (state is UpdateAddDeleteTourLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return OutlinedButton(
                      onPressed: () {
                        context.read<UpdateAddDeleteTourCubit>().deleteTour(
                          widget.tourId,
                        );
                        Navigator.pushReplacementNamed(context, '/adminScreen');
                        BlocProvider.of<TourCubit>(context).getAllTours();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.primaryColor,
                        side: const BorderSide(
                          color: ColorManager.primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text('حذف الرحلة', style: TextStyles.red12Bold),
                    );
                  },
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    BlocProvider.of<TourCubit>(context).getAllTours();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text('إغلاق', style: TextStyles.white12Bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyles.black14Bold),
          Text(label, style: TextStyles.black14Bold),
        ],
      ),
    );
  }
}
