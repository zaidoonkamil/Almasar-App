import 'package:delivery_app/features/delivery/navigation_bar_Delivery.dart';
import 'package:delivery_app/features/onboarding/onboarding.dart';
import 'package:delivery_app/features/vendor/view/home.dart';
import 'package:flutter/material.dart';

import '../../core/ navigation/navigation.dart';
import '../../core/network/local/cache_helper.dart';
import '../../core/widgets/constant.dart';
import '../admin/navigation_bar_admin.dart';
import '../auth/view/login.dart';
import '../delivery/view/changing_order.dart';
import '../user/navigation_bar_user.dart';
import '../user/view/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Widget? widget;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      if(CacheHelper.getData(key: 'token') == null){
        token='';
        if (onBoarding != null) {
          widget = const BottomNavBarUser();
        } else {
          widget = OnboardingScreen();
        }
      }else{
        if(CacheHelper.getData(key: 'role') == null){
          widget = const Login();
          adminOrUser='user';
        }else{
          adminOrUser = CacheHelper.getData(key: 'role');
          if (adminOrUser == 'admin') {
            widget = BottomNavBarAdmin();
          }else if(adminOrUser == 'delivery'){
            widget = BottomNavBarDelivery();
          }else if(adminOrUser == 'vendor'){
            widget = HomeVendor();
          }else{
            widget = BottomNavBarUser();
          }
        }
        token = CacheHelper.getData(key: 'token') ;
        id = CacheHelper.getData(key: 'id') ??'' ;
      }

      navigateAndFinish(context, widget);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Center(child:
                Image.asset('assets/images/logo.png',width: 300,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}