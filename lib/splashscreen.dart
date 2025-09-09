import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/get_it.dart' as DataCacheManager;
import 'package:opal_app/core/network/local_network.dart';

import 'features/Admin/presentaion/widgets/animated_spalsh.dart';

class DeciderPage extends StatefulWidget {
  const DeciderPage({super.key});

  @override
  State<DeciderPage> createState() => _DeciderPageState();
}

class _DeciderPageState extends State<DeciderPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize cache manager in background
    DataCacheManager.init();

    // Mark as initialized
    _isInitialized = true;
  }

  void _onSplashComplete() {
    if (_isInitialized) {
      _checkAuth();
    } else {
      // Fallback if initialization takes longer
      Future.delayed(const Duration(milliseconds: 100), _checkAuth);
    }
  }

  void _checkAuth() {
    token = CacheNetwork.getCacheData(key: 'access_token');
    role = CacheNetwork.getCacheData(key: 'access_role');

    if (token != null && token!.isNotEmpty) {
      switch (role) {
        case 'student':
          context.go('/home');
          break;
        case 'admin':
          context.go('/adminScreen');
          break;
        case 'supervisor':
          context.go('/supervisorScreen');
          break;
        default:
          context.go('/signin');
      }
    } else {
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(onComplete: _onSplashComplete);
  }
}
