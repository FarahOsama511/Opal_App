import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';

import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../pages/edit_trip_time.dart';

class TripDetailsDialog extends StatefulWidget {
  final String tourId;
  const TripDetailsDialog({required this.tourId});

  @override
  State<TripDetailsDialog> createState() => _TripDetailsDialogState();
}

bool _inInit = true;

class _TripDetailsDialogState extends State<TripDetailsDialog> {
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
      child: Container(
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
            const Center(
              child: Text(
                'بيانات الرحلة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
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
                        _buildRow('الخط', tour.line.name!, Colors.black),
                        _buildRow(
                          'ميعاد الذهاب',
                          '${DateFormat('yyyy-MM-dd').format(tour.leavesAt)} صباحاً',
                          Colors.black,
                        ),
                        _buildRow('اسم المشرف', tour.driverName, Colors.black),
                        _buildRow(
                          'تاريخ اليوم',
                          DateFormat('yyyy-MM-dd').format(tour.leavesAt),
                          Colors.black,
                        ),
                      ],
                    );
                  } else {
                    return Text("حدث خطأ في جلب البيانات");
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
                    child: EditTripBox(onClose: () => Navigator.pop(context)),
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
              child: const Text(
                'تعديل الرحلة',
                style: TextStyle(color: ColorManager.secondColor),
              ),
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
                    Navigator.pop(context);
                    BlocProvider.of<TourCubit>(context).getAllTours();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE71A45),
                    side: const BorderSide(color: Color(0xFFE71A45)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('حذف الرحلة'),
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
              child: const Text(
                'إغلاق',
                style: TextStyle(color: ColorManager.secondColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
          Text(label, style: TextStyle(color: valueColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}
