import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/app_header.dart'
    show AppHeader;
import 'package:opal_app/features/supervisor/supervisor_home_screen.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../Admin/Domain/entities/tour.dart';
import '../Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import '../Admin/presentaion/bloc/get_tour_bloc/tour_cubit.dart';
import '../Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import '../Admin/presentaion/widgets/bus_card.dart';
import '../Admin/presentaion/widgets/custom_widgets.dart';
import '../user/presentaion/bloc/auth_cubit.dart';
import '../user/presentaion/bloc/user_cubit.dart';
import '../user/presentaion/bloc/user_state.dart';

class ShowToursBySuperVisor extends StatefulWidget {
  final bool? isTripConfirmed;
  String? supervisorId;
  ShowToursBySuperVisor({
    super.key,
    this.isTripConfirmed = false,
    this.supervisorId,
  });

  @override
  State<ShowToursBySuperVisor> createState() => _ShowToursBySuperVisorState();
}

class _ShowToursBySuperVisorState extends State<ShowToursBySuperVisor> {
  int? expandedCardIndex;
  LineEntity? selectedLine;
  late bool isTripConfirmed;
  bool _inInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inInit) {
      BlocProvider.of<GetAllUserCubit>(
        context,
      ).getUserById(widget.supervisorId!);
      _inInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
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
                  onLogout: () async {
                    await CacheNetwork.deleteCacheData(key: 'access_token');
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  leadingWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<GetAllUserCubit, UserState>(
                        builder: (context, state) {
                          String lineName = '...';
                          if (state is UserByIdSuccess) {
                            print('LINEName:${state.userById.line!.name}');
                            lineName = state.userById.line?.name ?? 'غير معروف';
                          } else if (state is UserError) {
                            lineName = 'خط غير متاح';
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '!مرحباً ${context.read<AuthCubit>().user?.user.name ?? ''}',
                                style: TextStyles.black20Bold.copyWith(
                                  fontSize: 20.sp,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'مشرف الخط - $lineName',
                                style: TextStyles.black20Bold.copyWith(
                                  fontSize: 20.sp,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  titleWidget: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: Icon(Icons.logout, size: 24.sp),
                          ),
                          onPressed: () async {
                            await CacheNetwork.deleteCacheData(
                              key: 'access_token',
                            );
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('الرحلات', style: TextStyles.white20Bold),
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
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SupervisorScreen(
                                                tourId: tours[index].id ?? "",
                                                superVisorId:
                                                    widget.supervisorId ?? "",
                                              );
                                            },
                                          ),
                                        );
                                      },

                                      line: tours[index].line.name!,
                                      supervisorName:
                                          tours[index].driverName ?? "غير معرف",
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
