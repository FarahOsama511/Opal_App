import 'package:flutter/material.dart';
import 'package:opal_app/features/Tours/presentaion/pages/trips.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool showAddMenu = false;
  int currentIndex = 0;
  bool isStudentsSelected = true;
  bool isSupervisorSelected = true;

  List<bool> _isExpandedList = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              _buildSwitchButtons(),
              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: currentIndex,
                      children: [
                        _buildHomeContent(),
                        const TripsScreen(),
                        Center(child: Text(isStudentsSelected ? 'قائمة الطلاب' : 'قائمة المشرفين')),
                      ],
                    ),
                    _buildBottomNav(),
                  ],
                ),
              ),
            ],
          ),
          if (showAddMenu) _buildAddMenu(),
        ],
      ),
    );
  }

  Widget _buildSwitchButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStudentsSelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected ? const Color(0xFFE71A45) : Colors.grey.shade300,
              ),
              child: Text(
                'الطلاب',
                style: TextStyle(
                  color: isStudentsSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStudentsSelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected ? Colors.grey.shade300 : const Color(0xFFE71A45),
              ),
              child: Text(
                'المشرفين',
                style: TextStyle(
                  color: isStudentsSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE71A45),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildCard(index);
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isStudentsSelected ? ' مهاب محمد فوزى' : ' محمد احمد ',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpandedList[index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isExpandedList[index] = !_isExpandedList[index];
                  });
                },
              ),
            ],
          ),
          if (_isExpandedList[index])
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('رقم الهاتف:  "01012345678'),
                  Text('الجامعة: ${isStudentsSelected ? "جامعة القاهرة" : ""}'),
                  Text('الكلية: ${isStudentsSelected ? "حاسبات ومعلومات" : ""}'),
                  Text(isSupervisorSelected? 'الخط:      خط 1  ': '')
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE71A45),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: (index) {
              setState(() => currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
              BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'الرحلات'),
              BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: 'القائمة'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMenu() {
    return Positioned(
      top: 80,
      right: 16,
      left: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddOption('إضافة مسؤول جديد'),
              _buildAddOption('إضافة مشرف جديد'),
              _buildAddOption('إضافة ميعاد جديد'),
              _buildAddOption('إضافة خط جديد'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(String title) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFE71A45),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
