import 'package:bloc/bloc.dart';
import 'package:delivery_app/features/auth/view/login.dart';
import 'package:delivery_app/features/auth/view/register.dart';
import 'package:flutter/material.dart';

import 'bloc_observer.dart';
import 'core/network/local/cache_helper.dart';
import 'core/network/remote/dio_helper.dart';
import 'core/styles/themes.dart';
import 'features/delivery/navigation_bar_Delivery.dart';
import 'features/delivery/view/home.dart';
import 'features/splash/splash.dart';
import 'features/user/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeService().lightTheme,
      home: const SplashScreen(),
    );
  }
}
