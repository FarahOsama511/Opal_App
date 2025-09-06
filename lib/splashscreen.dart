import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/core/resources/color_manager.dart';

class DeciderPage extends StatefulWidget {
  const DeciderPage({super.key});

  @override
  State<DeciderPage> createState() => _DeciderPageState();
}

class _DeciderPageState extends State<DeciderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    token = CacheNetwork.getCacheData(key: 'access_token');
    role = CacheNetwork.getCacheData(key: 'access_role');

    if (token != null && token!.isNotEmpty) {
      if (role == 'student') {
        context.go('/home');
      } else if (role == 'admin') {
        context.go('/adminScreen');
      } else if (role == 'supervisor') {
        context.go('/supervisorScreen');
      } else {
        context.go('/signin');
      }
    } else {
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: ColorManager.primaryColor),
      ),
    );
  }
}
