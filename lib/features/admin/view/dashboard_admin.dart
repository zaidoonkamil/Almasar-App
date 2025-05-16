import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/StatCard.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getDashboardAdmin(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                navigateBack(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            Container(width: 46,height: 20,),
                          ],
                        ),
                      ),
                      ConditionalBuilder(
                          condition: cubit.getDashboard != null ,
                          builder: (c){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 26,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatCard(
                                        label: 'الطلبات المكتملة',
                                        icon: 'fluent-mdl2_completed.png',
                                        total: cubit.getDashboard!.totalOrders,
                                        used:  cubit.getDashboard!.completedOrders,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 10,),
                                      StatCard(
                                        label: 'الطلبات المبدلة',
                                        icon: 'mingcute_sandglass-2-line.png',
                                        total:  cubit.getDashboard!.totalOrders,
                                        used:   cubit.getDashboard!.exchangedOrders,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(width: 10,),
                                      StatCard(
                                        label: 'الطلبات الملغية',
                                        icon: 'material-symbols_cancel-outline-rounded.png',
                                        total: cubit.getDashboard!.totalOrders,
                                        used:  cubit.getDashboard!.cancelledOrders,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16,),
                                  Container(
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$ ',
                                                style: TextStyle(fontSize: 20, color: Colors.white),
                                              ),
                                              Text(
                                                cubit.getDashboard!.totalAmountIncludingFee.toString(),
                                                style: TextStyle(fontSize: 20, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'مبلغ الطلب\nالكلـــــــــــــي',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
                                              textAlign: TextAlign.end,
                                            ),
                                            SizedBox(width: 12),
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: CircularProgressIndicator(
                                                    value: cubit.getDashboard!.totalAmountIncludingFee.toDouble(),
                                                    strokeWidth: 4,
                                                    backgroundColor: Colors.white,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                ),
                                                Image.asset('assets/images/carbon_cur2rency.png'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatCard(
                                        label: 'رسوم التوصيل',
                                        icon: 'healthicons_vespa-motorcycle-outline.png',
                                        total: cubit.getDashboard!.totalAmountIncludingFee,
                                        used:  cubit.getDashboard!.totalDeliveryFee,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      SizedBox(width: 10,),
                                      StatCard(
                                        label: 'مبلغ الطلب',
                                        icon: 'carbon_currency.png',
                                        total: cubit.getDashboard!.totalAmountIncludingFee,
                                        used:  cubit.getDashboard!.totalOrderAmount,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 10,),
                                      StatCard(
                                        label: 'الطلبات الكلية',
                                        icon: 'solar_box-outline.png',
                                        total: cubit.getDashboard!.totalOrders,
                                        used:  cubit.getDashboard!.totalOrders,
                                        color: Colors.deepOrangeAccent,
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          fallback: (c)=>Center(child: CircularProgress())),
                    ],
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}
