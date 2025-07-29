import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/app_header.dart'
    show AppHeader;
import 'package:opal_app/features/selection/presentation/pages/confirm_details.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../../Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../../../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../../../Admin/presentaion/pages/trip_details.dart';
import '../../../Admin/presentaion/widgets/bus_card.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../user/presentaion/bloc/auth_cubit.dart';
import '../../../user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';

class UserHomeScreen extends StatefulWidget {
  final bool isTripConfirmed;
  const UserHomeScreen({super.key, this.isTripConfirmed = false});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int? expandedCardIndex;
  LineEntity? selectedLine;
  late bool isTripConfirmed;

  @override
  void initState() {
    super.initState();
    isTripConfirmed = widget.isTripConfirmed;
    BlocProvider.of<TourCubit>(context).getAllTours();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 210,
              top: -50,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset('assets/logos.png', width: 300, height: 300),
              ),
            ),
            Column(
              children: [
                AppHeader(
                  onLogout: () {
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  leadingWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '!مرحباً ${context.read<AuthCubit>().user?.user.name ?? ''}',
                        style: TextStyles.black20Bold,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'متى تريد الذهاب؟',
                        style: TextStyles.black20Bold,
                        // textAlign: TextAlign.right,
                      ),
                    ],
                  ),

                  titleWidget: Row(
                    children: [
                      IconButton(
                        icon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0),
                          child: Icon(Icons.logout),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (isTripConfirmed)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailsScreen(
                            tourId: context
                                .read<SelectionTourCubit>()
                                .TourConfirmedId!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        //color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorManager.blackColor),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عرض الرحلة الخاصة بك',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                    ),
                  )
                else
                  BlocBuilder<LinesCubit, GetAllLinesState>(
                    builder: (context, state) {
                      if (state is LinesLoading) {
                        return const CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        );
                      } else if (state is LinesLoaded) {
                        return CustomDropdown(
                          label: 'اختر الخط الخاص بك',
                          value: selectedLine,
                          items: state.Liness,
                          onChanged: (value) {
                            setState(() => selectedLine = value);
                          },
                          displayString: (u) => u.name!,
                        );
                      } else {
                        return const Text('فشل في تحميل الخطوط');
                      }
                    },
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'مواعبد الذهاب _ العودة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        BlocBuilder<TourCubit, TourState>(
                          builder: (context, state) {
                            if (state is TourLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.secondColor,
                                ),
                              );
                            } else if (state is TourLoaded) {
                              final tours = selectedLine == null
                                  ? state.tours
                                  : state.tours
                                        .where(
                                          (t) =>
                                              t.line.name == selectedLine!.name,
                                        )
                                        .toList();

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: tours.length,
                                  itemBuilder: (context, index) {
                                    final isExpanded =
                                        index == expandedCardIndex;
                                    return BusCard(
                                      isExpanded: isExpanded,
                                      onTap: isTripConfirmed
                                          ? null
                                          : () async {
                                              expandedCardIndex = isExpanded
                                                  ? null
                                                  : index;
                                              final confirmed =
                                                  await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) =>
                                                        ConfirmDetailsScreen(
                                                          tourId:
                                                              tours[index].id!,
                                                        ),
                                                  );

                                              if (confirmed == true) {
                                                setState(() {
                                                  isTripConfirmed = true;
                                                });
                                              }
                                            },

                                      line: tours[index].line.name!,
                                      supervisorName: tours[index].driverName,
                                      departureTime: DateFormat(
                                        'HH:mm',
                                      ).format(tours[index].leavesAt),
                                      date: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(tours[index].leavesAt),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'حدث خطأ أثناء تحميل الرحلات',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
