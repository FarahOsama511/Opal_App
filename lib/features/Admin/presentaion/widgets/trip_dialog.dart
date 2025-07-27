import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _TripDetailsDialogState extends State<TripDetailsDialog> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRow('الخط', 'خط رقم 1', Colors.black),
                  _buildRow('ميعاد الذهاب', '7:00 صباحاً', Colors.black),
                  _buildRow('اسم المشرف', 'أحمد محمد أحمد', Colors.black),
                  _buildRow('تاريخ اليوم', '22/6/2025', Colors.black),
                ],
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
              child: const Text('تعديل الرحلة'),
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
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('إغلاق'),
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
