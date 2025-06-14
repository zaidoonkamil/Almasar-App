import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'all_order.dart';
import 'changing_order.dart';

class OrderAdmin extends StatelessWidget {
  const OrderAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
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
                       navigateTo(context, ChangingOrdersAdmin());
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
                       navigateTo(context, AllOrdersAdmin(urll: '/admin/all-orders',));
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
                  SizedBox(height: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        navigateTo(context, AllOrdersAdmin(urll: '/admin/returned-or-exchanged-orders',));
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
                          child: Text('الطلبيات المعلقة',
                            style: TextStyle(color: primaryColor,fontSize: 16 ),
                          ),
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
