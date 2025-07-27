import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
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
        value: context.read<UpdateAddDeleteTourCubit>(), // ❗ نعيد تمرير الموجود
        child: TripDetailsDialog(tourId: tourId),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE71A45),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "مواعيد الرحلات",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFE71A45),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: BlocConsumer<TourCubit, TourState>(
                  listener: (context, state) {
                    if (state is TourError) {
                      print("error in trips:${state}");
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is TourLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is TourLoaded) {
                      if (state.tours.isEmpty) {
                        return Center(
                          child: Text(
                            "لا توجد رحلات حاليا",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.tours.length,
                        itemBuilder: (context, index) {
                          String tourId = state.tours[index].id;
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
                      return Center(child: Text("ERROR"));
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
