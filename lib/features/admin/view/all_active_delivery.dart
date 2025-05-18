import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/features/admin/view/changing_order.dart';
import 'package:delivery_app/features/admin/view/details_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AllActiveDelivery extends StatelessWidget {
  const AllActiveDelivery({super.key, required this.idOrder});

  final String idOrder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AdminCubit();
        cubit.startAutoRefreshActiveDelivery(context: context);
        return cubit;
      },
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is DeliveriesAssignOrderSuccessState){
            navigateAndFinish(context, ChangingOrdersAdmin());
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        SizedBox(height: 26,),
                        ConditionalBuilder(
                          condition: cubit.getActiveDeliveryModel != null,
                          builder: (c){
                            return ConditionalBuilder(
                                condition: cubit.getActiveDeliveryModel!.isNotEmpty,
                                builder: (c){
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cubit.getActiveDeliveryModel!.length,
                                      itemBuilder:(context,index){
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      title: Column(
                                                        children: [
                                                          Text("هل حقا ترغب في تتوجيه الطلب الى",
                                                            style: TextStyle(fontSize: 18),
                                                            textAlign: TextAlign.center,),
                                                          Text("(${cubit.getActiveDeliveryModel![index].name})",
                                                            style: TextStyle(fontSize: 18),
                                                            textAlign: TextAlign.center,),
                                                        ],
                                                      ),
                                                      content: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("إلغاء",style: TextStyle(color: primaryColor),),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: primaryColor,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              cubit.deliveriesAssignOrder(
                                                                context: context,
                                                                deliveryId: cubit.getActiveDeliveryModel![index].id.toString(),
                                                                idOrder: idOrder,
                                                              );
                                                            },
                                                            child: Text("نعم",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                                height: 45,
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Image.asset('assets/images/fluent_person-16-filled.png'),
                                                    Text(
                                                      cubit.getActiveDeliveryModel![index].name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${index+1} #',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12,),
                                          ],
                                        );
                                      });
                                },
                                fallback: (c)=>Column(
                                  children: [
                                    SizedBox(height: 200,),
                                    Center(child: Text('لا يوجد بيانات ليتم عرضها',style: TextStyle(fontSize: 16),)),
                                  ],
                                )
                            );
                          },
                          fallback: (c)=>Center(child: CircularProgress(),),
                        ),
                        SizedBox(height: 80,),
                      ],
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}
