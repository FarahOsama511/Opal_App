import 'package:flutter/material.dart';
import 'confirmation_success.dart';

class ConfirmDetailsScreen extends StatelessWidget {
  const ConfirmDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 50,
              right: -90,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),
              ),
            ),

            Column(
              children: [
                const _Header(),

                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // اللوجو الأصفر داخل الكارد
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.08,
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 180,
                                  color: Colors.amber,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          // محتوى الكارد
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'بيانات الذهاب و العودة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const _RowInfo(label: 'الخط', value: 'خط رقم 1'),
                              const _RowInfo(label: 'ميعاد الذهاب', value: '7:00 صباحاً'),
                              const _RowInfo(label: 'ميعاد العودة', value: '3:00 مساءً'),
                              const _RowInfo(label: 'اسم المشرف', value: 'أحمد محمد أحمد'),
                              const _RowInfo(label: 'تاريخ اليوم', value: '22/6/2025'),
                              const SizedBox(height: 20),

                              // زر تأكيد
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ConfirmationSuccessScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE71A45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'تأكيد',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // زر السابق
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'السابق',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;

  const _RowInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child:  Row(
        children: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
          const SizedBox(width: 10),
          const Icon(Icons.person),
          Spacer(),
          Text(
            'متى تريد الذهاب؟',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
