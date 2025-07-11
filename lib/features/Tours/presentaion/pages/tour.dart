import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../bloc/get_tour_bloc/tour_state.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<TourCubit>().getAllTours();
              },
              child: const Text("Get Tours"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TourCubit, TourState>(
                builder: (context, state) {
                  if (state is TourLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TourLoaded) {
                    final tours = state.tours;
                    return ListView.builder(
                      itemCount: tours.length,
                      itemBuilder: (context, index) {
                        final tour = tours[index];
                        return ListTile(
                          title: Text(tour.driverName),
                          subtitle: Text(tour.type),
                        );
                      },
                    );
                  } else if (state is TourError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(
                      child: Text('Press button to get tours.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
