import 'package:flutter/material.dart';
import '../widgets/expandable_card.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});
  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  final List<Map<String, String>> students = [
    {
      'name': 'لوجين اشرف',
      'phone': '01098765432',
      'university': 'جامعة عين شمس',
      'faculty': 'كلية علاج طبيعى',
    },
    {
      'name': 'يمنى أسامة',
      'phone': '01012345678',
      'university': 'جامعة القاهرة',
      'faculty': 'كلية حاسبات',
    },
  ];
  late List<bool> expandedList;
  @override
  void initState() {
    super.initState();
    expandedList = List.generate(students.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE71A45),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(color: Colors.white),
          ),
          Positioned(
            top: -2,
            right: -90,
            child: Opacity(
              opacity: 0.25,
              child: Image.asset('assets/logo.png', width: 200, height: 200),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'مرحباً مهاب!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'مشرف خط 1',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          //  await SessionManager.clearSession();
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFE71A45),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'عدد الطلاب:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${students.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return ExpandableCard(
                          name: student['name'] ?? '',
                          phone: student['phone'] ?? '',
                          university: student['university'] ?? '',

                          line: '',
                          isSupervisor: false,
                          isExpanded: expandedList[index],
                          onToggle: () {
                            setState(() {
                              expandedList[index] = !expandedList[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
