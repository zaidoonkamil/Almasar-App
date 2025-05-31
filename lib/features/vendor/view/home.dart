import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/features/user/view/orders.dart';
import 'package:delivery_app/features/vendor/view/profile.dart';
import 'package:delivery_app/features/user/view/request_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'my_proudcts.dart';
import 'orders.dart';

class HomeVendor extends StatelessWidget {
  const HomeVendor({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;
  static int currentIndex = 0;
  static DateTime? lastBackPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => VendorCubit()..verifyToken(context: context)..getAds(context: context)..getProfile(context: context),
      child: BlocConsumer<VendorCubit,VendorStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=VendorCubit.get(context);
          return SafeArea(
            child: WillPopScope(
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
                backgroundColor: const Color(0xFFF2F2F7),
                appBar: AppBar(
                  title: Column(
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
                body:
                ConditionalBuilder(
                    condition: cubit.profileModel != null && cubit.getAdsModel.isNotEmpty,
                    builder: (c){
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: GestureDetector(
                                          onTap:(){
                                            navigateTo(context, ProfileVendor(
                                              name: cubit.profileModel!.name,
                                              phone: cubit.profileModel!.phone,
                                              image: cubit.profileModel!.images[0],));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    '! مرحباا مجددا',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.right,
                                                    cubit.profileModel!.name,
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 8,),
                                              Image.asset('assets/images/Group 1171275632.png'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 18,),
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
                                                    children: List.generate(
                                                        cubit.getAdsModel.length, (index) {
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
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            navigateTo(context, RequestDelivery());
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  blurRadius: 6,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: const Text(
                                                'طلب مندوب توصيل',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 14,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            navigateTo(context, OrdersVendor());
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  blurRadius: 6,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: const Text(
                                                'حالة الطلبيات',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 14,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: GestureDetector(
                                          onTap: (){
                                           navigateTo(context, MyProducts());
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  blurRadius: 6,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: const Text(
                                                'منتجاتي',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    fallback: (c)=>Center(child: CircularProgress())),

              ),
            ),
          );
        },
      ),
    );
  }
}
