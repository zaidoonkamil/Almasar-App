import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/features/auth/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'complete_shopping.dart';
import 'details.dart';

class Basket extends StatelessWidget {
  const Basket({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getCart(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = UserCubit.get(context);
          return SafeArea(
              child: Scaffold(
                body: ConditionalBuilder(
                  condition: state is !GetCartLoadingState,
                    builder: (context){
                      return ConditionalBuilder(
                          condition: cubit.getCartModel.isNotEmpty,
                          builder: (c){
                            return Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CustomAppbar(),
                                      SizedBox(height: 12,),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: cubit.getCartModel.length,
                                          itemBuilder:(context,index){
                                            DateTime dateTime = DateTime.parse(cubit.getCartModel[index].productt.createdAt.toString());
                                            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                                            int number = int.parse(cubit.getCartModel[index].productt.price.toString());
                                            return GestureDetector(
                                              onTap: (){
                                                navigateTo(context, Details(
                                                  id: cubit.getCartModel[index].productt.id.toString(),
                                                  tittle: cubit.getCartModel[index].productt.title.toString(),
                                                  description: cubit.getCartModel[index].productt.description.toString(),
                                                  price: cubit.getCartModel[index].productt.price.toString(),
                                                  images: cubit.getCartModel[index].productt.images,
                                                  formattedDate: formattedDate,
                                                ));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(12),
                                                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      spreadRadius: 2,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: (){
                                                              cubit.deleteProductsInCart( context: context,
                                                                  id: cubit.getCartModel[index].id.toString());
                                                            },
                                                            child: Image.asset('assets/images/Card options icon.png')),
                                                        SizedBox(width: 12,),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(cubit.getCartModel[index].productt.title.toString()),
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
                                                              '$url/uploads/${cubit.getCartModel[index].productt.images[0].toString()}',
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('د.ع',style: TextStyle(color: primaryColor),),
                                                            SizedBox(width: 4,),
                                                            Text(NumberFormat('#,###').format(number).toString()),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(cubit.getCartModel[index].quantity.toString()),
                                                            Text(' : العدد'),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      SizedBox(height: 140,),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
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
                                            GestureDetector(
                                              onTap: () {
                                                navigateTo(
                                                  context,
                                                  CompleteShopping(
                                                    products: cubit.getCartModel.map<Map<String, dynamic>>((task) {
                                                      return {
                                                        "productId": task.productId,
                                                        "quantity": task.quantity,
                                                      };
                                                    }).toList(),
                                                    idVendor: cubit.getCartModel[0].productt.vendorId.toString(),
                                                  ),
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
                                                    Text('اكمال عملية الشراء',
                                                      style: TextStyle(color: Colors.white,fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        fallback: (context)=>
                            Column(
                              children: [
                                CustomAppbar(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('لا يوجد منتجات ليتم عرضها'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  fallback: (context)=>
                      Column(
                        children: [
                          CustomAppbar(),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               token != '' ? CircularProgress():
                               GestureDetector(
                                 onTap: (){
                                   navigateTo(context, Login());
                                 },
                                 child: Container(
                                   width: 180,
                                   height: 48,
                                   decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.black.withOpacity(0.2),
                                           blurRadius: 10,
                                           spreadRadius: 2,
                                           offset: const Offset(5, 5),
                                         ),
                                       ],
                                       borderRadius:  BorderRadius.circular(30),
                                       color: primaryColor
                                   ),
                                   child: Center(
                                     child: Text('تسجيل الدخول',
                                       style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                   ),
                                 ),
                               ),
                              ],
                            ),
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
