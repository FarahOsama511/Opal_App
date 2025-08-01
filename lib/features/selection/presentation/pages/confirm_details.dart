import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_state.dart';
import '../../../../core/resources/text_styles.dart';
import 'confirmation_success.dart';

class ConfirmDetailsScreen extends StatefulWidget {
  final String tourId;
  const ConfirmDetailsScreen({super.key, required this.tourId});

  @override
  State<ConfirmDetailsScreen> createState() => _ConfirmDetailsScreenState();
}

class _ConfirmDetailsScreenState extends State<ConfirmDetailsScreen> {
  @override
  void initState() {
    super.initState();
    //  BlocProvider.of<SelectionTourCubit>(context).selectionTour(widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorManager.secondColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocListener<SelectionTourCubit, SelectionTourState>(
          listener: (context, state) {
            if (state is SelectionTourSuccess) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const ConfirmationSuccessScreen(),
              );
            } else if (state is SelectionTourError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'فشل في تأكيد البيانات',
                    style: TextStyles.white12Bold,
                  ),
                  backgroundColor: ColorManager.greyColor,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'بيانات الذهاب و العودة',
                    style: TextStyles.black14Bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.blackColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocBuilder<SelectionTourCubit, SelectionTourState>(
                    builder: (context, state) {
                      if (state is SelectionTourLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryColor,
                          ),
                        );
                      } else if (state is SelectionTourSuccess) {
                        final tour = state.tour;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _RowInfo(label: 'الخط', value: tour.line.name!),
                            _RowInfo(
                              label: 'ميعاد ${tour.type ?? "الذهاب"}',
                              value:
                                  '${DateFormat('HH:mm').format(tour.leavesAt)} صباحاً',
                            ),
                            _RowInfo(
                              label: 'اسم المشرف',
                              value: tour.driverName ?? "غير معرف",
                            ),
                            _RowInfo(
                              label: 'تاريخ اليوم',
                              value:
                                  '${DateFormat('yyyy-MM-dd').format(tour.leavesAt)}',
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            "فشل في جلب البيانات",
                            style: TextStyles.black14Bold,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SelectionTourCubit>().selectionTour(
                        widget.tourId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE71A45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('تأكيد', style: TextStyles.white14Bold),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('السابق', style: TextStyles.white14Bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;

  const _RowInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
