import 'package:delivery_app/features/user/view/basket.dart';
import 'package:delivery_app/features/user/view/home.dart';
import 'package:delivery_app/features/user/view/orders.dart';
import 'package:delivery_app/features/user/view/profile.dart';
import 'package:delivery_app/features/user/view/request_delivery.dart';
import 'package:flutter/material.dart';

import '../../core/styles/themes.dart';
import '../../core/widgets/show_toast.dart';

class BottomNavBarUser extends StatefulWidget {
  const BottomNavBarUser({super.key,this.initialIndex=4,});

  final int initialIndex;

  @override
  State<BottomNavBarUser> createState() => _BottomNavBarUserState();
}

class _BottomNavBarUserState extends State<BottomNavBarUser> {
  late int currentIndex;
  DateTime? lastBackPressed;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  List<Widget> screens = [
    ProfileUser(),
    RequestDelivery(),
    Orders(),
    Basket(),
    Home(),
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
        backgroundColor: Colors.white,
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
            type: BottomNavigationBarType.fixed,
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
                label: "اضافة",
                icon:  currentIndex==1?Image.asset('assets/images/material-symbols_orders-rounded.png'):
                Image.asset('assets/images/material-symbols_orders-outline-rounded.png'),
              ),
              BottomNavigationBarItem(
                label: "الطلبات",
                icon:  currentIndex==2?Image.asset('assets/images/solar_cart-bold.png'):
                Image.asset('assets/images/solar_cart-broken.png'),
              ),
              BottomNavigationBarItem(
                label: "السلة",
                icon:  currentIndex==3?Image.asset('assets/images/solar_cart-bold (1).png'):
                Image.asset('assets/images/solars_cart-broken.png'),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==4?Image.asset('assets/images/mingcute_home-3-fill.png'):
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