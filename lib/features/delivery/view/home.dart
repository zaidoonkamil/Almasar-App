import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/features/delivery/view/dashboard.dart';
import 'package:delivery_app/features/delivery/view/today_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/StatCard.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HomeDelivery extends StatelessWidget {
  const HomeDelivery({super.key});

  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DeliveryCubit()
        ..verifyToken(context: context)..getAds(context: context)..getProfile(context: context),
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=DeliveryCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'شركة المسار',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'للتوصيل الداخلي السريع',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConditionalBuilder(
                      condition: cubit.profileModel != null,
                      builder: (c){
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                SizedBox(height: 26,),
                                Column(
                                  children: [
                                    ConditionalBuilder(
                                      condition:cubit.getAdsModel.isNotEmpty,
                                      builder:(c){
                                        return Column(
                                          children: [
                                            CarouselSlider(
                                              items: cubit.getAdsModel.expand((entry) => entry.images.map((imageUrl) => Builder(
                                                builder: (BuildContext context) {
                                                  return SizedBox(
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      child: Image.network(
                                                        "$url/uploads/$imageUrl",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))).toList(),
                                              options: CarouselOptions(
                                                height: 180,
                                                viewportFraction: 0.94,
                                                enlargeCenterPage: true,
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                reverse: true,
                                                autoPlay: true,
                                                autoPlayInterval: const Duration(seconds: 6),
                                                autoPlayAnimationDuration:
                                                const Duration(seconds: 1),
                                                autoPlayCurve: Curves.fastOutSlowIn,
                                                scrollDirection: Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  currentIndex=index;
                                                  cubit.slid();
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: List.generate(cubit.getAdsModel.length, (index) {
                                                return Container(
                                                  width: currentIndex == index ? 30 : 8,
                                                  height: 7.0,
                                                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: currentIndex == index
                                                        ? primaryColor
                                                        : const Color(0XFFC1D1F9),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                      fallback: (c)=> Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 60.0),
                                        child: CircularProgressIndicator(color: primaryColor,),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 26,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: LiteRollingSwitch(
                                    value: cubit.profileModel!.isActive,
                                    textOn: 'نشط',
                                    textOff: 'غير نشط',
                                    colorOn: Colors.green.withOpacity(0.9),
                                    colorOff: Colors.redAccent,
                                    iconOn: Icons.done,
                                    iconOff: Icons.remove_circle_outline,
                                    textSize: 16.0,
                                    textOnColor: Colors.white,
                                    textOffColor: Colors.white,
                                    onChanged: (bool state) {
                                      cubit.deliveryStatus(
                                        context: context,
                                        isActive: !cubit.profileModel!.isActive,
                                      );
                                      },
                                    onTap: (){},
                                    onDoubleTap:(){},
                                    onSwipe: (){},
                                  ),
                                ),
                                SizedBox(height: 18,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          navigateTo(context, TodayDashboard());
                                        },
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                                offset: const Offset(5, 5),
                                              ),
                                            ],
                                            borderRadius:  BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text('الاحصائية اليومية',
                                              style: TextStyle(color: primaryColor,fontSize: 16 ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12,),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          navigateTo(context, DashboardDelivery());
                                        },
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(5, 5),
                                                ),
                                              ],
                                              borderRadius:  BorderRadius.circular(12),
                                              color: primaryColor
                                          ),
                                          child: Center(
                                            child: Text('الاحصائية الكلية',
                                              style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 26,),
                                Container(
                                  // padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      cubit.getCurrentLocation(context: context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: const Offset(5, 5),
                                            ),
                                          ],
                                          borderRadius:  BorderRadius.circular(12),
                                          color: primaryColor
                                      ),
                                      child: Center(
                                        child: Text('تحديد موقعي الحالي',
                                          style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                              ],
                            ),
                          ),
                        );
                      },
                      fallback: (c)=>Expanded(child: Center(child: CircularProgress()))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
