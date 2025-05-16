import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/features/user/view/orders.dart';
import 'package:delivery_app/features/user/view/profile.dart';
import 'package:delivery_app/features/user/view/request_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;
  static int currentIndex = 0;
  static List<String> adsImages = [
    'assets/images/60560-01-e-commerce-powerpoint-template-16x9-2.webp',
    'assets/images/60560-01-e-commerce-powerpoint-template-16x9-2.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getAds(context: context)..getProfile(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              appBar: AppBar(
                centerTitle: true,
                title: Container(
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
              ),
              body: ConditionalBuilder(
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
                                          navigateTo(context, Profile(
                                            name: cubit.profileModel!.name,
                                            phone: cubit.profileModel!.phone,));
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
                                                  children: List.generate(adsImages.length, (index) {
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
                                          height: 200,
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
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          navigateTo(context, Orders());
                                        },
                                        child: Container(
                                          width: double.maxFinite,
                                          height: 200,
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
                                    SizedBox(height: 30,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           navigateTo(context, RequestDelivery());
                        //         },
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Container(
                        //               width: 60,
                        //               height: 60,
                        //               decoration: BoxDecoration(
                        //                 color: primaryColor,
                        //                 shape: BoxShape.circle,
                        //                 boxShadow: [
                        //                   BoxShadow(
                        //                     color: Colors.blue.withOpacity(0.3),
                        //                     blurRadius: 6,
                        //                     offset: Offset(0, 3),
                        //                   ),
                        //                 ],
                        //               ),
                        //               child: Center(
                        //                 child: Icon(
                        //                   Icons.add,
                        //                   color: Colors.white,
                        //                   size: 42,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                  },
                  fallback: (c)=>Center(child: CircularProgress())),
            ),
          );
        },
      ),
    );
  }
}
