import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AllOrdersAdmin extends StatelessWidget {
  const AllOrdersAdmin({super.key, required this.urll, required this.appBarText});

  final String urll;
  final String appBarText;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..allOrder(page: '1',context: context, url: urll,),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
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
                        Text(
                          appBarText,
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
                    condition: cubit.allOrderModel != null,
                    builder: (c){
                      return ConditionalBuilder(
                          condition: cubit.allOrderModel!.pagination.totalPages != 0,
                          builder: (c){
                            return Expanded(
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: cubit.orders.length,
                                  itemBuilder: (context,index){
                                    DateTime dateTime = DateTime.parse(cubit.orders[index].createdAt.toString());
                                    String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                    String formattedTime = DateFormat('h:mm a').format(dateTime);
                                    if (index == cubit.orders.length - 1 && !cubit.isLastPage) {
                                      cubit.allOrder(page: (cubit.currentPage + 1).toString(),context:context, url: urll);
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
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${cubit.orders[index].id}",
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
                                                color:cubit.orders[index].status == 'تم الاستلام'?
                                                Colors.blue.withOpacity(0.1):cubit.orders[index].status == 'تم التسليم'?
                                                Colors.green.withOpacity(0.1):cubit.orders[index].status == 'استرجاع الطلب'?
                                                Colors.red.withOpacity(0.1):Colors.orange.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                cubit.orders[index].status,
                                                style: TextStyle(
                                                  color: cubit.orders[index].status == 'تم الاستلام'?
                                                  Colors.blue:cubit.orders[index].status == 'تم التسليم'?
                                                  Colors.green:cubit.orders[index].status == 'استرجاع الطلب'?
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
                                                GestureDetector(
                                                  onTap: () async {
                                                    final url = 'tel:${cubit.orders[index].phone}';
                                                    await launch(
                                                      url,
                                                      enableJavaScript: true,
                                                    ).catchError((e) {
                                                      showToastError(
                                                        text: e.toString(),
                                                        context: context,
                                                      );
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text( cubit.orders[index].phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.phone_outlined, color: Colors.grey),
                                                    ],
                                                  ),
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
                                                    Text(cubit.orders[index].address,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14), overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),
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
                                                cubit.orders[index].items != null && cubit.orders[index].items!.isNotEmpty
                                                    ?Container():Row(
                                                  children: [
                                                    Text(
                                                      'د.ع ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.orders[index].deliveryFee.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
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
                                                        fontSize: 14,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.orders[index].orderAmount.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
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
                                                    fontSize: 14,
                                                    // color: Color(0xFFFE6B35),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                cubit.orders[index].notes == ''? Expanded(
                                                  child: Text(
                                                    'لا يوجد',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ):Expanded(
                                                  child: Text(
                                                    cubit.orders[index].notes,
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Column(
                                              children: [
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': المستخدم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.person_outline, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].user.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.phone_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(child: Text( cubit.orders[index].user.location,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                            cubit.orders[index].rejectionReason != '' ?Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ': سبب رفض الدلفري',
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        cubit.orders[index].rejectionReason,
                                                        textAlign: TextAlign.end,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          // color: Color(0xFFFE6B35),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].delivery != null ?Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': الدليفري',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].delivery!.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.person_outline, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final url = 'tel:${cubit.orders[index].delivery!.phone}';
                                                    await launch(
                                                      url,
                                                      enableJavaScript: true,
                                                    ).catchError((e) {
                                                      showToastError(
                                                        text: e.toString(),
                                                        context: context,
                                                      );
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text( cubit.orders[index].delivery!.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.phone_outlined, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].delivery!.location,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( DateFormat('yyyy/M/d').format(DateTime.parse(cubit.orders[index].statusHistory.last.changeDate.toString())).toString()
                                                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.date_range, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( DateFormat('h:mm a').format(DateTime.parse(cubit.orders[index].statusHistory.last.changeDate.toString())).toString()
                                                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.data_exploration, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].statusHistory.last.status != "تم الاستلام"
                                                && cubit.orders[index].statusHistory.last.status != "تم التسليم"
                                                && (cubit.orders[index].statusHistory.last.note?.isNotEmpty ?? false)
                                                ?Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': سبب الحالة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(child: Text(
                                                      cubit.orders[index].statusHistory.last.note!,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.note_alt_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].items != null && cubit.orders[index].items!.isNotEmpty ?Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                Container(width: double.maxFinite,height: 2,color: Colors.grey,),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      physics: AlwaysScrollableScrollPhysics(),
                                                      itemCount: cubit.orders[index].items?.length,
                                                      itemBuilder:(context,itemIndex){
                                                        int number = int.parse(cubit.orders[index].items![itemIndex].product.price.toString());
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
                                                                          Text(cubit.orders[index].items![itemIndex].product.title.toString(),
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
                                                                      '$url/uploads/${cubit.orders[index].items![itemIndex].product.images[0].toString()}',
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text('${itemIndex+1}',style: TextStyle(color: primaryColor,fontSize: 14),),
                                                                    SizedBox(width: 2,),
                                                                    Text('#',style: TextStyle(fontSize: 14),),
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
