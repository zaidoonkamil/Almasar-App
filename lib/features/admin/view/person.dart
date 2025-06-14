import 'package:delivery_app/features/admin/view/all_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Person extends StatelessWidget {
  const Person({super.key});

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
                           navigateTo(context, AllPerson(role: 'Admin'));
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
                          child: Text('الادمن',
                            style: TextStyle(color: Colors.white,fontSize: 16 ),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        navigateTo(context, AllPerson(role: 'Only'));
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
                          child: Text('المستخدمون',
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
                        navigateTo(context, AllPerson(role: 'Delivery'));
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
                          child: Text('الدليفري',
                            style: TextStyle(color: Colors.white,fontSize: 16 ),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        navigateTo(context, AllPerson(role: 'vendor'));
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
                          child: Text('التجار',
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
