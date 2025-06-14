import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/features/delivery/view/changing_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'all_order.dart';

class OrderDelivery extends StatelessWidget {
  const OrderDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DeliveryCubit(),
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=DeliveryCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                  CustomAppbar(),
                  SizedBox(height: 40,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        navigateTo(context, ChangingOrdersDelivery());
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        height: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(5, 5),
                            ),
                          ],
                          borderRadius:  BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text('الطلبيات الواردة',
                            style: TextStyle(color: primaryColor,fontSize: 16 ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        navigateTo(context, AllOrdersDelivery(id: id,));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        height: 200,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(5, 5),
                              ),
                            ],
                            borderRadius:  BorderRadius.circular(12),
                            color: primaryColor
                        ),
                        child: Center(
                          child: Text('الطلبيات المقبولة',
                            style: TextStyle(color: Colors.white,fontSize: 16 ),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
