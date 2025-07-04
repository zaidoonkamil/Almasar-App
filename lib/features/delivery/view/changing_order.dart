import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChangingOrdersDelivery extends StatelessWidget {
  const ChangingOrdersDelivery({super.key,});

  static TextEditingController noteController = TextEditingController();
  static TextEditingController noteRController = TextEditingController();
  static TextEditingController noteCController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = DeliveryCubit();
        cubit.startAutoRefresh(context: context);
        return cubit;
      },
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){
          if(state is ChangeStatusOrderSuccessState){
            navigateBack(context);
          }
          if(state is DeliveryAcceptSuccessState){
            showToastSuccess(
              text:"تمت العملية بنجاح",
              context: context,
            );
            noteController.text='';
            noteCController.text='';
            noteRController.text='';
          }
        },
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
                          condition: cubit.getActiveOrdersModel!.isNotEmpty,
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
                                                Colors.red.withOpacity(0.1):Colors.orange.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                cubit.getActiveOrdersModel![index].status,
                                                style: TextStyle(
                                                  color: cubit.getActiveOrdersModel![index].status == 'تم الاستلام'?
                                                  Colors.blue:cubit.getActiveOrdersModel![index].status == 'تم التسليم'?
                                                  Colors.green:cubit.getActiveOrdersModel![index].status == 'استرجاع الطلب'?
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
                                                  final url = 'tel:${cubit.getActiveOrdersModel![index].phone}';
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
                                                      Text( cubit.getActiveOrdersModel![index].phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
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
                                                cubit.getActiveOrdersModel![index].items != null && cubit.getActiveOrdersModel![index].items!.isNotEmpty
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
                                            cubit.getActiveOrdersModel![index].items != null && cubit.getActiveOrdersModel![index].items!.isNotEmpty ?Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                Container(width: double.maxFinite,height: 2,color: Colors.grey,),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      physics: AlwaysScrollableScrollPhysics(),
                                                      itemCount: cubit.getActiveOrdersModel![index].items?.length,
                                                      itemBuilder:(context,itemIndex){
                                                        int number = int.parse(cubit.getActiveOrdersModel![index].items![itemIndex].product.price.toString());
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
                                                                          Text(cubit.getActiveOrdersModel![index].items![itemIndex].product.title.toString(),
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
                                                                      '$url/uploads/${cubit.getActiveOrdersModel![index].items![itemIndex].product.images[0].toString()}',
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
                                            // cubit.getActiveOrdersModel![index].items != null && cubit.getActiveOrdersModel![index].items!.isNotEmpty ?
                                            //     Container():Column(
                                            //   children: [
                                            //     const SizedBox(height: 8),
                                            //     Row(
                                            //       mainAxisAlignment: MainAxisAlignment.end,
                                            //       children: [
                                            //         Text( cubit.getActiveOrdersModel![index].user.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            //         const SizedBox(width: 6),
                                            //         const Icon(Icons.phone_outlined, color: Colors.grey),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            cubit.getActiveOrdersModel![index].isAccepted == true?Container(): Column(
                                              children: [
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ConditionalBuilder(
                                                      condition: state is! DeliveryAcceptLoadingState,
                                                      builder: (c)=> GestureDetector(
                                                        onTap:(){
                                                          cubit.deliveryAccept(
                                                              context: context,
                                                              accept: true,
                                                              rejectionReason: '',
                                                              idOrder: cubit.getActiveOrdersModel![index].id.toString());
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green.withOpacity(0.8),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child:Text(
                                                            'قبول',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      fallback: (c)=>CircularProgressIndicator(color:Colors.green.withOpacity(0.8),),
                                                    ),
                                                    ConditionalBuilder(
                                                      condition: state is! DeliveryAcceptLoadingState,
                                                      builder: (c)=> GestureDetector(
                                                        onTap:(){
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                backgroundColor:  Color(0xFFF5F5F8),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                title: Column(
                                                                  children: [
                                                                    Text("! رجائا ادخل سبب رفض الطلب ",
                                                                      style: TextStyle(fontSize: 18),
                                                                      textAlign: TextAlign.center,),
                                                                    SizedBox(height: 20,),
                                                                    CustomTextField(
                                                                      controller: noteController,
                                                                      hintText: 'سبب رفض الطلب',
                                                                      prefixIcon: Icons.note_alt_outlined,
                                                                      keyboardType: TextInputType.text,
                                                                    ),
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
                                                                        if(noteController.text.trim() == ''){
                                                                          showToastInfo(
                                                                              text: 'رجائا ادخل سبب الرفض',
                                                                              context: context);
                                                                        }else{
                                                                          cubit.deliveryAccept(
                                                                              context: context,
                                                                              accept: false,
                                                                              rejectionReason: noteController.text.trim(),
                                                                              idOrder: cubit.getActiveOrdersModel![index].id.toString());
                                                                          navigateBack(context);
                                                                        }

                                                                      },
                                                                      child: Text("ارسال",style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );

                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red.withOpacity(0.8),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child:Text(
                                                            'رفض',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      fallback: (c)=>CircularProgressIndicator(color:Colors.red.withOpacity(0.8),),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "تغيير حالة الطلب",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ConditionalBuilder(
                                                  condition: state is! ChangeStatusOrderLoadingState,
                                                  builder: (c)=> GestureDetector(
                                                    onTap:(){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor:  Color(0xFFF5F5F8),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            title: Text("هل حقا ترغب في تغيير الحالة الى (تم التسليم) ؟",
                                                              style: TextStyle(fontSize: 18),
                                                              textAlign: TextAlign.center,),
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
                                                                    cubit.changeStatusOrder(
                                                                        context: context,
                                                                        status: "تم التسليم",
                                                                        idOrder: cubit.getActiveOrdersModel![index].id.toString(),
                                                                      note: '',
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
                                                      width: 100,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(0.8),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child:Text(
                                                        "تم التسليم",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  fallback: (c)=>CircularProgressIndicator(color:Colors.green.withOpacity(0.8),),
                                                ),
                                                ConditionalBuilder(
                                                  condition: state is! ChangeStatusOrderLoadingState,
                                                  builder: (c)=> GestureDetector(
                                                    onTap:(){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor:  Color(0xFFF5F5F8),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            title: Column(
                                                              children: [
                                                                Text("هل حقا ترغب في تغيير الحالة الى (تبديل الطلب) ؟",
                                                                  style: TextStyle(fontSize: 18),
                                                                  textAlign: TextAlign.center,),
                                                                SizedBox(height: 20,),
                                                                CustomTextField(
                                                                  controller: noteRController,
                                                                  hintText: 'سبب تبديل الطلب',
                                                                  prefixIcon: Icons.note_alt_outlined,
                                                                  keyboardType: TextInputType.text,
                                                                ),
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
                                                                    if(noteRController.text.trim() == ''){
                                                                      showToastInfo(
                                                                        text: 'رجائا ادخل سبب الرفض',
                                                                        context: context,
                                                                      );
                                                                    }else{
                                                                      cubit.changeStatusOrder(
                                                                        context: context,
                                                                        status: "تبديل الطلب",
                                                                        note: noteRController.text.trim(),
                                                                        idOrder: cubit.getActiveOrdersModel![index].id.toString(),
                                                                      );
                                                                      navigateBack(context);
                                                                    }
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
                                                      width: 70,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange.withOpacity(0.8),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child:Text(
                                                        "تبديل",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  fallback: (c)=>CircularProgressIndicator(color:Colors.orange.withOpacity(0.8),),
                                                ),
                                                ConditionalBuilder(
                                                  condition: state is! ChangeStatusOrderLoadingState,
                                                  builder: (c)=> GestureDetector(
                                                    onTap:(){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor:  Color(0xFFF5F5F8),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            title: Column(
                                                              children: [
                                                                Text("هل حقا ترغب في تغيير الحالة الى (استرجاع الطلب) ؟",
                                                                  style: TextStyle(fontSize: 18),
                                                                  textAlign: TextAlign.center,),
                                                                SizedBox(height: 20,),
                                                                CustomTextField(
                                                                  controller: noteCController,
                                                                  hintText: 'سبب استرجاع الطلب',
                                                                  prefixIcon: Icons.note_alt_outlined,
                                                                  keyboardType: TextInputType.text,
                                                                ),
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
                                                                    if(noteCController.text.trim() == ''){
                                                                      showToastInfo(
                                                                          text: 'رجائا ادخل سبب الرفض',
                                                                          context: context,
                                                                      );
                                                                    }else{
                                                                      cubit.changeStatusOrder(
                                                                        context: context,
                                                                        status: "استرجاع الطلب",
                                                                        note: noteCController.text.trim(),
                                                                        idOrder: cubit.getActiveOrdersModel![index].id.toString(),
                                                                      );
                                                                      navigateBack(context);
                                                                    }
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
                                                      width: 100,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.withOpacity(0.8),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child:Text(
                                                        "استرجاع",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  fallback: (c)=>CircularProgressIndicator(color:Colors.red.withOpacity(0.8),),
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
