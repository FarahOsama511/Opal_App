import 'package:flutter/material.dart';

class ConfirmationSuccessScreen extends StatelessWidget {
  const ConfirmationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),

            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                    minHeight: 350,
                  ),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // اللوجو الأصفر فوق النص في النص
                      Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 200,
                          color: Colors.amber,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'تم التأكيد',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.check_circle, color: Colors.green, size: 80),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE71A45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                          },
                          child: const Text(
                            'العودة إلى الرئيسية',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
      child: Row(
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