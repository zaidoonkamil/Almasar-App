import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class OrdersVendor extends StatelessWidget {
  const OrdersVendor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => VendorCubit()..getOrder(context: context, page: '1'),
      child: BlocConsumer<VendorCubit,VendorStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=VendorCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'تقرير الطلبيات',
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
                    condition: cubit.orderModel != null,
                    builder: (c){
                      return ConditionalBuilder(
                          condition: state is! GetOrderLoadingState,
                          builder: (c){
                            return Expanded(
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: cubit.orderModel!.orders.length,
                                  itemBuilder: (context,index){
                                    DateTime dateTime = DateTime.parse(cubit.orderModel!.orders[index].createdAt.toString());
                                    String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                    if (index == cubit.orders.length - 1 && !cubit.isLastPage) {
                                      cubit.getOrder(page: (cubit.currentPage + 1).toString());
                                    }
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                cubit.orderModel!.orders[index].items != null && cubit.orderModel!.orders[index].items!.isNotEmpty ?
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Text(
                                                    'وارد',
                                                    style: TextStyle(
                                                      color:Colors.orange,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ):Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Text(
                                                    'صادر',
                                                    style: TextStyle(
                                                      color:Colors.green,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
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
                                                color:cubit.orderModel!.orders[index].status == 'تم الاستلام'?
                                                Colors.blue.withOpacity(0.1):cubit.orderModel!.orders[index].status == 'تم التسليم'?
                                                Colors.green.withOpacity(0.1):cubit.orderModel!.orders[index].status == 'استرجاع الطلب'?
                                                Colors.red.withOpacity(0.1):Colors.orange.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                cubit.orderModel!.orders[index].status,
                                                style: TextStyle(
                                                  color: cubit.orderModel!.orders[index].status == 'تم الاستلام'?
                                                  Colors.blue:cubit.orderModel!.orders[index].status == 'تم التسليم'?
                                                  Colors.green:cubit.orderModel!.orders[index].status == 'استرجاع الطلب'?
                                                  Colors.red:Colors.orange,
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
                                                    Text( cubit.orderModel!.orders[index].phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.person, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Expanded(child: Text(cubit.orderModel!.orders[index].address,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18), overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)),
                                                const SizedBox(width: 6),
                                                const Icon(Icons.location_on, color: Colors.grey),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                cubit.orderModel!.orders[index].items != null && cubit.orderModel!.orders[index].items!.isNotEmpty
                                                    ?Container():Row(
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
                                                      cubit.orderModel!.orders[index].deliveryFee.toString(),
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
                                                      cubit.orderModel!.orders[index].orderAmount.toString(),
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
                                                cubit.orderModel!.orders[index].notes == ''? Expanded(
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
                                                    cubit.orderModel!.orders[index].notes,
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
                                            cubit.orderModel!.orders[index].items != null && cubit.orderModel!.orders[index].items!.isNotEmpty ?
                                            Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                Container(width: double.maxFinite,height: 2,color: Colors.grey,),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      physics: AlwaysScrollableScrollPhysics(),
                                                      itemCount: cubit.orderModel!.orders[index].items?.length,
                                                      itemBuilder:(context,itemIndex){
                                                        int number = int.parse(cubit.orderModel!.orders[index].items![itemIndex].product.price.toString());
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(width: 12,),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(cubit.orderModel!.orders[index].items![itemIndex].product.title.toString(),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 4,),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text('د.ع',style: TextStyle(color: primaryColor),),
                                                                          SizedBox(width: 4,),
                                                                          Text(NumberFormat('#,###').format(number).toString()),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(width: 12,),
                                                                Container(
                                                                  width: 64,
                                                                  height: 64,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius.circular(6.0),
                                                                    child: Image.network(
                                                                      '$url/uploads/${cubit.orderModel!.orders[index].items![itemIndex].product.images[0].toString()}',
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text('${itemIndex+1}',style: TextStyle(color: primaryColor,fontSize: 18),),
                                                                    SizedBox(width: 2,),
                                                                    Text('#',style: TextStyle(fontSize: 18),),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ):const SizedBox(height: 12),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          },
                          fallback: (c)=>Expanded(child: Center(child: Text('لا يوجد بيانات ليتم عرضها'))));
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
