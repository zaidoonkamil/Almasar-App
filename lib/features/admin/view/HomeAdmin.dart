import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/core/widgets/custom_appbar.dart';
import 'package:delivery_app/features/admin/view/add_notification.dart';
import 'package:delivery_app/features/admin/view/today_dashboard_admin.dart';
import 'package:delivery_app/features/delivery/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/StatCard.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'dashboard_admin.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
       ..getAds(context: context)..getProfile(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                  CustomAppbar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 26,),
                            Column(
                              children: [
                                ConditionalBuilder(
                                    condition: cubit.getAdsModel != [],
                                    builder: (c){
                                  return ConditionalBuilder(
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
                                      fallback: (c)=> Container(),
                                  );
                                },
                                    fallback: (c)=>Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                                  child: CircularProgressIndicator(color: primaryColor,),
                                )
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    cubit.deleteAds(
                                        id: cubit.getAdsModel[currentIndex].id.toString(),
                                        context: context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.red
                                      ),
                                      child: Icon(Icons.delete,color: Colors.white,)),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    cubit.selectedImages.isNotEmpty?
                                    cubit.addAds(context: context):cubit.pickImages();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.blue
                                      ),
                                      child:cubit.selectedImages.isNotEmpty?
                                      Text('رفع الصورة',style: TextStyle(color: Colors.white),):
                                      Icon(Icons.add_a_photo_outlined,color: Colors.white,)
                                  ),
                                ),
                              ],
                            ),
                            cubit.selectedImages.isNotEmpty ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cubit.selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.file(File(cubit.selectedImages[index].path), height: 150),
                                  );
                                },
                              ),
                            ):Container(),
                            SizedBox(height: 24,),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, TodayDashboardAdmin());
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
                                          style: TextStyle(color: primaryColor,fontSize: 14 ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12,),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                     navigateTo(context, DashboardAdmin());
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
                                          style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18,),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                     navigateTo(context, AddNotification());
                                    },
                                    child: Container(
                                      height: 55,
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
                                        child: Text('ارسال اشعار',
                                          style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
