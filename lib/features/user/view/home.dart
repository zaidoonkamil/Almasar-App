import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/features/user/view/orders.dart';
import 'package:delivery_app/features/user/view/products_vendor.dart';
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

class Home extends StatelessWidget {
  const Home({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;
  static int currentIndex = 0;
  static DateTime? lastBackPressed;
  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getAds(context: context)
        ..getProfile(context: context)
        ..verifyToken(context: context)
        ..getVendor(page: '1', context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
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
                body: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                    Expanded(
                      child: ConditionalBuilder(
                          condition: cubit.profileModel != null ,
                          builder: (c){
                            return Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                                                child: Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 26,),
                                        ConditionalBuilder(
                                            condition: cubit.vendorModel != null,
                                            builder: (c){
                                              return GridView.custom(
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                                                controller: scrollController,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 4,
                                                  mainAxisSpacing: 1,
                                                  childAspectRatio: 0.8,
                                                ),
                                                childrenDelegate: SliverChildBuilderDelegate(
                                                  childCount: cubit.vendorModel!.data.length,
                                                      (context, index) {
                                                        if (index == cubit.vendorModel!.data.length - 1 && !cubit.isLastPageVendor) {
                                                          cubit.getVendor(page: (cubit.currentPageVendor + 1).toString(), context: context);
                                                        }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        navigateTo(context, ProductsVendor(
                                                          idVendor: cubit.vendorModel!.data[index].id.toString(),
                                                          image: cubit.vendorModel!.data[index].images[0],
                                                          name: cubit.vendorModel!.data[index].name,
                                                          phone: cubit.vendorModel!.data[index].phone,
                                                        ));
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: double.maxFinite,
                                                            margin: const EdgeInsets.all(4),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(6),
                                                              child: Image.network(
                                                                "$url/uploads/${cubit.vendorModel!.data[index].images[0]}",
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.all(4),
                                                                padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                                                                width: double.maxFinite,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(cubit.vendorModel!.data[index].name,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          cubit.vendorModel!.data[index].sponsorshipAmount !=0 ?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                                                margin: const EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.orange.withOpacity(0.2),
                                                                  borderRadius: BorderRadius.circular(30),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Text('موصى به',style: TextStyle(color: Colors.orange),
                                                                    textAlign: TextAlign.end,),
                                                                    Image.asset('assets/images/solar_fire-bold.png'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ):Container(),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            fallback: (c)=>Center(child: CircularProgress())),
                                        SizedBox(height: 30,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          fallback: (c)=>Center(child: CircularProgress())),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
