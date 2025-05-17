import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChangingOrdersDelivery extends StatelessWidget {
  const ChangingOrdersDelivery({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DeliveryCubit()..getActiveOrder(context: context,),
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=DeliveryCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
              body: Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: (){
                              navigateBack(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new,size: 28,)),
                        const Text(
                          'الطلبيات النشطة',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ConditionalBuilder(
                    condition: cubit.getActiveOrdersModel != null,
                    builder: (c){
                      return ConditionalBuilder(
                          condition: true,
                          builder: (c){
                            return Expanded(
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: cubit.getActiveOrdersModel!.length,
                                  itemBuilder: (context,index){
                                    DateTime dateTime = DateTime.parse(cubit.getActiveOrdersModel![index].createdAt.toString());
                                    String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                    String formattedTime = DateFormat('h:mm a').format(dateTime);
                                    return  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${index+1}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      " طلب #",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              width: double.maxFinite,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              decoration: BoxDecoration(
                                                color:cubit.getActiveOrdersModel![index].status == 'تم الاستلام'?
                                                Colors.blue.withOpacity(0.1):cubit.getActiveOrdersModel![index].status == 'تم التسليم'?
                                                Colors.green.withOpacity(0.1):cubit.getActiveOrdersModel![index].status == 'استرجاع الطلب'?
                                                Colors.red.withOpacity(0.1):Colors.yellowAccent.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                cubit.getActiveOrdersModel![index].status,
                                                style: TextStyle(
                                                  color: cubit.getActiveOrdersModel![index].status == 'تم الاستلام'?
                                                  Colors.blue:cubit.getActiveOrdersModel![index].status == 'تم التسليم'?
                                                  Colors.green:cubit.getActiveOrdersModel![index].status == 'استرجاع الطلب'?
                                                  Colors.red:Colors.yellowAccent,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text( cubit.getActiveOrdersModel![index].phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.phone_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedTime ,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(cubit.getActiveOrdersModel![index].address,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18), overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'د.ع ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.getActiveOrdersModel![index].deliveryFee.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Icon(Icons.delivery_dining, color: Colors.grey),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ' د.ع ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.getActiveOrdersModel![index].orderAmount.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Icon(Icons.price_change_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  ': ملاحظات',
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    // color: Color(0xFFFE6B35),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                cubit.getActiveOrdersModel![index].notes == ''? Expanded(
                                                  child: Text(
                                                    'لا يوجد',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ):Expanded(
                                                  child: Text(
                                                    cubit.getActiveOrdersModel![index].notes,
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text( cubit.getActiveOrdersModel![index].user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                const SizedBox(width: 6),
                                                const Icon(Icons.person_outline, color: Colors.grey),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text( cubit.getActiveOrdersModel![index].user.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                const SizedBox(width: 6),
                                                const Icon(Icons.phone_outlined, color: Colors.grey),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    'قبول',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    'رفض',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                          },
                          fallback: (c)=>Expanded(child: Center(child: Text('لا يوجد بيانات ليتم عرضها',style: TextStyle(fontSize: 16),))));
                    },
                    fallback: (c)=>Expanded(child: Center(child: CircularProgress())),
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
