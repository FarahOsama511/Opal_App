import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/auth/presentaion/bloc/auth_cubit.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات مؤقتة للعرض
    final List<Map<String, String>> students = [
      {
        'name': 'يمنى أسامة',
        'phone': '01012345678',
        'university': 'جامعة القاهرة',
        'faculty': 'كلية حاسبات',
      },
      {
        'name': 'يمنى اسامه',
        'phone': '01098765432',
        'university': 'جامعة عين شمس',
        'faculty': 'كلية هندسة',
      },
    ];
    final user = context.read<AuthCubit>().user?.user.name ?? 'مجهول';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // الجزء العلوي المعدل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.person),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$user",
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
                      const SizedBox(width: 10),
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // كل الخلفية الحمراء ومحتواها
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
                          return StudentTile(student: student);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  final Map<String, String> student;
  const StudentTile({super.key, required this.student});

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.student['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: const Color(0xFFE71A45),
              ),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('رقم الهاتف: ${widget.student['phone']}'),
                  Text('الجامعة: ${widget.student['university']}'),
                  Text('الكلية: ${widget.student['faculty']}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
