import 'package:delivery_app/features/auth/view/login.dart';
import 'package:delivery_app/features/delivery/view/home.dart';
import 'package:delivery_app/features/delivery/view/order.dart';
import 'package:delivery_app/features/delivery/view/profile.dart';
import 'package:delivery_app/features/user/view/home.dart';
import 'package:flutter/material.dart';

import '../../core/styles/themes.dart';
import '../../core/widgets/show_toast.dart';

class BottomNavBarDelivery extends StatefulWidget {
  const BottomNavBarDelivery({super.key});

  @override
  State<BottomNavBarDelivery> createState() => _BottomNavBarDeliveryState();
}

class _BottomNavBarDeliveryState extends State<BottomNavBarDelivery> {
  int currentIndex = 1;
  DateTime? lastBackPressed;
  List<Widget> screens = [
    ProfileDelivery(),
    OrderDelivery(),
    HomeDelivery(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastBackPressed == null || now.difference(lastBackPressed!) > Duration(seconds: 2)) {
          lastBackPressed = now;
          showToastInfo(
            text: "اضغط مرة اخرى للخروج من التطبيق",
            context: context,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, -3)
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedItemColor: primaryColor,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                label: "الحساب",
                icon:  currentIndex==0?Image.asset('assets/images/fluent_person-16-filled.png'):
                Image.asset('assets/images/fluent_person-16-regular (1).png'),
              ),
              BottomNavigationBarItem(
                label: "الطلبات",
                icon:  currentIndex==1?Image.asset('assets/images/solar_cart-bold.png'):
                Image.asset('assets/images/solar_cart-broken.png'),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==2?Image.asset('assets/images/mingcute_home-3-fill.png'):
                Image.asset('assets/images/mingcute_home-3-line.png'),
              ),
            ],
            onTap: (val) {
              setState(() {
                currentIndex = val;
              });
            },
          ),
        ),
      ),
    );
  }
}