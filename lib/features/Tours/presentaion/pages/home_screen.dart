import 'package:flutter/material.dart';
import 'package:opal_app/features/Tours/presentaion/pages/trips.dart';
import 'add_trip_time.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool showAddMenu = false;
  int currentIndex = 0;
  bool showAddTripBox = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: currentIndex,
                        children: [
                          _buildHomeContent(),
                          const TripsScreen(),
                          // const StudentList(),
                        ],
                      ),
                      _buildBottomNav(),
                    ],
                  ),
                ),
              ],
            ),
            if (showAddMenu) _buildAddMenu(),
            if (showAddTripBox)
              Positioned(
                top: 150,
                left: 20,
                right: 20,
                child: AddTripBox(
                  onClose: () => setState(() => showAddTripBox = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signin');
              // أو تستخدم pushReplacement عشان ما تقدرش ترجع للصفحة السابقة
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignInScreen()));
            },
          ),
          Image.asset('assets/logo.png', height: 60),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {
              setState(() => showAddMenu = !showAddMenu);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFE71A45)),
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 90,
        ),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildSupervisorCard('مهاب محمد فوزى');
          },
        ),
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
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alt_route),
                label: 'الرحلات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                label: 'قائمة الطلاب',
              ),
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
              _buildAddOption('إضافة مسؤول جديد', () {
                Navigator.pushNamed(context, '/addAdmin');
              }),
              _buildAddOption('إضافة مشرف جديد', () {
                Navigator.pushNamed(context, '/addSupervisor');
              }),
              _buildAddOption('إضافة ميعاد جديد', () {
                setState(() {
                  showAddTripBox = true;
                  showAddMenu = false;
                });
              }),
              _buildAddOption('إضافة خط جديد', () {
                Navigator.pushNamed(context, '/addBusLine');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
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

  Widget _buildSupervisorCard(String name) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
        ],
      ),
    );
  }
}
