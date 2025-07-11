import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Tours/Data/repositiries/tour_repo_impl.dart';
import 'package:opal_app/features/Tours/Domain/reporistires/tour_repo.dart';
import 'package:opal_app/features/Tours/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import 'package:opal_app/features/Tours/presentaion/pages/tour.dart';

import 'features/Tours/Domain/usecase/get_all_tours.dart';
import 'features/Tours/presentaion/bloc/get_tour_bloc/tour_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TourPage(),
    );
  }
}
