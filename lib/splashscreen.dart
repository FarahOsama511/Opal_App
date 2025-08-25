import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoggedIn = false;
  bool isStudent = false;
  bool isAdmin = false;

  checkToken() async {
    if (token != null && token != "") {
      if (role == 'student') {
        isStudent = true;
        isAdmin = false;
        isLoggedIn = true;
        Navigator.pushReplacementNamed(context, '/home');
      } else if (role == 'admin') {
        isStudent = false;
        isAdmin = true;
        isLoggedIn = true;
        Navigator.pushReplacementNamed(context, '/adminScreen');
      } else if (role == 'supervisor') {
        isStudent = false;
        isAdmin = false;
        isLoggedIn = true;
        Navigator.pushReplacementNamed(context, '/supervisorScreen');
      }
    } else {
      isStudent = false;
      isAdmin = false;
      isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () async {
      await checkToken();
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE71A45),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 0.35.sw,
              ),
              SizedBox(height: 20.h),
              Text(
                'Opal',
                style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
