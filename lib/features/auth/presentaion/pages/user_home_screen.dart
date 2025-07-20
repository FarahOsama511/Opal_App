import 'package:flutter/material.dart';
import '../../../Tours/presentaion/widgets/app_header.dart';
import '../../../Tours/presentaion/widgets/bus_card.dart';
import '../../../Tours/presentaion/widgets/bus_line_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? expandedCardIndex;
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              onLogout: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              leadingWidget: Row(
                mainAxisSize: MainAxisSize.min,
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
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '!مرحباً مهاب',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'متى تريد الذهاب؟',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              trailingWidget: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/logo.png',
                  width: 60,
                  height: 60,
                ),
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 12),

            BusLineDropdown(
              selectedLine: selectedLine,
              onChanged: (value) {
                setState(() {
                  selectedLine = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE71A45),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'مواعيد الذهاب',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final isExpanded = index == expandedCardIndex;
                          return BusCard(
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                expandedCardIndex = isExpanded ? null : index;
                              });
                            },
                            onCancel: () {
                              setState(() {
                                expandedCardIndex = null;
                              });
                            },
                            onNext: () {
                              Navigator.pushNamed(context, '/confirm');
                            },
                            line: 'خط رقم 1',
                            supervisorName: 'أحمد محمد أحمد',
                            departureTime: '7:00 صباحاً',
                            date: '22/6/2025',
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
      ),
    );
  }
}
