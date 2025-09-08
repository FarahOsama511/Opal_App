import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../user/Domain/entities/user_entity.dart';
import '../widgets/search_field.dart';
import '../widgets/expandable_card.dart';

class ReservationsPage extends StatefulWidget {
  Tour tour;
  ReservationsPage({super.key, required this.tour});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<bool>? expandedList;
  @override
  void initState() {
    super.initState();
    if (expandedList == null ||
        expandedList!.length != widget.tour.users!.length) {
      final usersLength = widget.tour.users?.length ?? 0;
      expandedList = List.generate(usersLength, (_) => false);
      print("====${usersLength}====");
    }
  }

  List<UserEntity> users = [];
  List<UserEntity> filteredUsers = [];

  void _searchFunction(String keyWord) {
    setState(() {
      filteredUsers = users.where((user) {
        return user.line!.name!.toLowerCase().contains(keyWord.toLowerCase()) ||
            user.name!.toLowerCase().contains(keyWord.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'الحجوزات',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchField(
            hintText: 'ابحث ',
            onChanged: _searchFunction,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            fillColor: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عدد الطلاب: ${widget.tour.users?.length ?? "5"}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: ColorManager.primaryColor,
              child: ListView.builder(
                itemCount: widget.tour.users?.length ?? 0,
                itemBuilder: (context, index) {
                  users = widget.tour.users!;
                  final user = widget.tour.users![index];
                  return ExpandableCard(
                    name: user.name ?? '',
                    phone: user.phone ?? '',
                    university: user.university,
                    isSupervisor: false,
                    isExpanded: expandedList![index],
                    onToggle: () {
                      setState(() {
                        expandedList![index] = !expandedList![index];
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
