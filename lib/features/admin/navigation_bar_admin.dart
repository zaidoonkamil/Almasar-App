import 'package:delivery_app/features/admin/view/HomeAdmin.dart';
import 'package:delivery_app/features/admin/view/add_person.dart';
import 'package:delivery_app/features/admin/view/order.dart';
import 'package:delivery_app/features/admin/view/person.dart';
import 'package:delivery_app/features/admin/view/profile.dart';
import 'package:flutter/material.dart';

import '../../core/styles/themes.dart';
import '../../core/widgets/show_toast.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key,this.initialIndex=4,});

  final int initialIndex;

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  late int currentIndex;
  DateTime? lastBackPressed;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  List<Widget> screens = [
    ProfileAdmin(),
    AddPerson(),
    Person(),
    OrderAdmin(),
    HomeAdmin(),
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
                icon:  currentIndex==1?Image.asset('assets/images/fluent_person-add-20-filled.png'):
                Image.asset('assets/images/fluent_person-add-20-regular.png'),
              ),
              BottomNavigationBarItem(
                label: "الاشخاص",
                icon:  currentIndex==2?Image.asset('assets/images/fluent_person-key-20-filled.png'):
                Image.asset('assets/images/fluent_person-key-20-regular.png'),
              ),
              BottomNavigationBarItem(
                label: "الطلبات",
                icon:  currentIndex==3?Image.asset('assets/images/solar_cart-bold.png'):
                Image.asset('assets/images/solar_cart-broken.png'),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==4?Image.asset('assets/imag'
                    ''
                    'es/mingcute_home-3-fill.png'):
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