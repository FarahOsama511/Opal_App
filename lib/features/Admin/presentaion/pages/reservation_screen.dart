import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/resources/text_styles.dart';
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

  List<UserEntity> users = [];
  List<UserEntity> filteredUsers = [];
  List<String> universities = []; // الجامعات اللي هتظهر كفلاتر

  @override
  void initState() {
    super.initState();
    users = widget.tour.users ?? [];
    filteredUsers = users;

    // جهزي expandedList
    expandedList = List.generate(users.length, (_) => false);

    // استخرجي الجامعات من الـ users بدون تكرار
    universities = users
        .map((u) => u.university?.name ?? "")
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  void _searchFunction(String keyWord) {
    setState(() {
      filteredUsers = users.where((user) {
        final uni = user.university?.name?.toLowerCase() ?? "";
        final line = user.line?.name?.toLowerCase() ?? "";
        final name = user.name?.toLowerCase() ?? "";

        return uni.contains(keyWord.toLowerCase()) ||
            line.contains(keyWord.toLowerCase()) ||
            name.contains(keyWord.toLowerCase());
      }).toList();
    });
  }

  void _filterByUniversity(String uniName) {
    setState(() {
      filteredUsers = users
          .where(
            (user) =>
                (user.university?.name ?? "").toLowerCase() ==
                uniName.toLowerCase(),
          )
          .toList();
    });
  }

  void _clearFilter() {
    setState(() {
      filteredUsers = List<UserEntity>.from(users);
    });
  }

  /// تصفير كل الحجوزات من السيرفر
  Future<void> _clearAllReservations() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("تأكيد"),
        content: Text(
          "هل أنت متأكد من تصفير كل الحجوزات لهذه الرحلة؟",
          style: TextStyles.black14Bold,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("إلغاء", style: TextStyles.red10Bold),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("تصفير", style: TextStyles.red10Bold),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        for (final user in users) {
          final response = await http.delete(
            Uri.parse("${Base_Url}tours/${widget.tour.id}/users/${user.id}"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          );

          if (response.statusCode != 200 && response.statusCode != 204) {
            print("فشل حذف ${user.name}");
          }
        }

        // بعد الحذف كله
        setState(() {
          users.clear();
          filteredUsers.clear();
          universities.clear();
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("تم تصفير كل الحجوزات بنجاح ✅")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ أثناء الاتصال بالسيرفر ⚠️")),
        );
      }
    }
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
        actions: [
          IconButton(
            onPressed: _clearAllReservations,
            icon: Icon(Icons.delete_forever, color: Colors.red, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          /// search
          SearchField(
            hintText: 'ابحث ',
            onChanged: _searchFunction,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            fillColor: Colors.white,
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategory("الكل", _clearFilter),
                ...universities.map(
                  (uni) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: _buildCategory(uni, () => _filterByUniversity(uni)),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عدد الطلاب: ${filteredUsers.length}',
                style: TextStyles.white14Bold.copyWith(fontSize: 20),
              ),
            ),
          ),

          /// القائمة
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
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
        ],
      ),
    );
  }

  Widget _buildCategory(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.black14Bold,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
