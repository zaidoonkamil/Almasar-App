import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class Details extends StatelessWidget {
  const Details({super.key,
    required this.id,
    required this.tittle,
    required this.description,
    required this.price,
    required this.images,
    required this.formattedDate,
  });

  static CarouselController carouselController = CarouselController();

  static int currentIndex = 0;
  final String id;
  final String tittle;
  final String description;
  final String price;
  final String formattedDate;
  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      UserCubit(),//..createDatabase(),
      child: BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit=UserCubit.get(context);
            int number = int.parse(price);
            return SafeArea(
              child: Scaffold(
                backgroundColor: Color(0XFFF6F6F6),
                body: Stack(
                  children: [
                    Column(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  navigateBack(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Icon(Icons.arrow_back_ios_new),
                                ),
                              ),
                              Column(
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
                              Container(width: 40,)
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                                children: [
                                  ConditionalBuilder(
                                    condition: true,
                                    builder:(c){
                                      return Column(
                                        children: [
                                          Container(
                                            height: 373,
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(borderRadius:
                                            BorderRadius.circular(16)),
                                            child: Stack(
                                              children: [
                                                CarouselSlider(
                                                  items:images!.map((entry) {
                                                    return Builder(
                                                      builder: (BuildContext context) {
                                                        return SizedBox(
                                                          width: double.maxFinite,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(16.0),
                                                            child: Image.network(
                                                              "$url/uploads/$entry",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                  options: CarouselOptions(
                                                    height: 343,
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
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 16),
                                                  width: double.maxFinite,
                                                  height: double.maxFinite,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: images!.asMap().entries.map((entry) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          carouselController.animateTo(
                                                            entry.key.toDouble(),
                                                            duration: Duration(milliseconds: 500),
                                                            curve: Curves.easeInOut,
                                                          );
                                                        },
                                                        child: Container(
                                                          width: currentIndex == entry.key ? 8 : 8,
                                                          height: 7.0,
                                                          margin: const EdgeInsets.symmetric(
                                                            horizontal: 3.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: currentIndex == entry.key
                                                                  ? primaryColor
                                                                  : Colors.white),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    fallback: (c)=> CircularProgress(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(child:
                                            Text(tittle,
                                              style: TextStyle(fontSize: 20,color: Colors.black87),
                                              textAlign: TextAlign.end,
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(56),
                                                  color: Color(0XFF767B90)
                                              ),
                                              child: Text('جديد',style: TextStyle(color: Colors.white),),
                                            ),
                                            Row(
                                              children: [
                                                Text('د.ع',style: TextStyle(fontSize: 20,color: primaryColor),),
                                                Text(NumberFormat('#,###').format(number).toString(),style: TextStyle(fontSize: 20,color: primaryColor),),
                                              ],
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(formattedDate),
                                                SizedBox(width: 4,),
                                                Image.asset('assets/images/solar_calendar-broken (1).png',width: 20,height: 20,),
                                              ],
                                            ),

                                            Text(':وصف المنتج',
                                              style: TextStyle(fontSize: 16,color: Colors.black),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(description,
                                                style: TextStyle(fontSize: 20,color: Colors.grey),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 200,),
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical:16 ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                       cubit.minus(c: context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(60),
                                            color: Colors.white
                                        ),
                                        child: Icon(Icons.minimize),
                                      ),
                                    ),
                                   Text(cubit.quantity.toString(),style: TextStyle(fontSize: 24),),
                                    GestureDetector(
                                      onTap: (){
                                       cubit.add();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(60),
                                            color: Colors.white
                                        ),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: (){
                                    cubit.addProductsToCart(
                                      productId: id ,
                                      context: context,
                                    );
                                  },
                                  child: Container(
                                    width: double.maxFinite,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('أضف للسلة',
                                          style: TextStyle(color: Colors.white,fontSize: 16),
                                        ),
                                        SizedBox(width: 8,),
                                        Image.asset('assets/images/shopping-cart-02 (1).png'),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
