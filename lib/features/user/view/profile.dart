import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/features/auth/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class ProfileUser extends StatelessWidget {
  const ProfileUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getProfile(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
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
                      child: Column(
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
                    ),
                    SizedBox(height: 64,),
                    ConditionalBuilder(
                        condition: cubit.profileModel != null,
                        builder: (context){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.profileModel!.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4,),
                                    Text(
                                      cubit.profileModel!.phone,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 6,),
                               Image.asset('assets/images/Group 1171275632 (1).png'),
                              ],
                            ),

                          );
                        },
                        fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,))
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded),
                                  Row(
                                    children: [
                                      Text(
                                        'من نحن',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 4,),
                                      Image.asset('assets/images/info-circle.png'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6,),
                              Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                              SizedBox(height: 14,),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/Group 1171275618.png'),
                                      SizedBox(width: 4,),
                                      Image.asset('assets/images/Group 1171275617.png'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'الاتصال المباشر بالدعم',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 4,),
                                      Image.asset('assets/images/Vector (1).png'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6,),
                              Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                              SizedBox(height: 14,),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded),
                                  Row(
                                    children: [
                                      Text(
                                        'تقييم التطبيق',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 4,),
                                      Image.asset('assets/images/solar_star-line-duotone.png'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6,),
                              Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                              SizedBox(height: 14,),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded),
                                  Row(
                                    children: [
                                      Text(
                                        'مشاركة التطبيق',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 4,),
                                      Image.asset('assets/images/octicon_share-16.png'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6,),
                              Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                              SizedBox(height: 14,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 90,),
                        token !=''? GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text("هل حقا ترغب في تسجيل الخروج ؟",
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
                                          signOut(context);
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
                            height: 41,
                            width: double.maxFinite,
                            color: primaryColor.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/Group 6892.png'),
                                Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20,height: 10,),
                              ],
                            ),
                          ),
                        ):
                        GestureDetector(
                          onTap: (){
                            navigateTo(context, Login());
                          },
                          child: Container(
                            height: 41,
                            width: double.maxFinite,
                            color: primaryColor.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/Group 6892.png'),
                                Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20,height: 10,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        token !=''?GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text("هل حقا ترغب في حذف الحساب ؟",
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
                                          Navigator.of(context).pop();
                                          showToastInfo(
                                              text: 'تم ارسال طلبك وسوف يتم الرد عليك قريبا',
                                              context: context);
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
                            height: 41,
                            width: double.maxFinite,
                            color: primaryColor.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/hugeicons_delete-02.png'),
                                Text(
                                  'حذف الحساب',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20,height: 10,),
                              ],
                            ),
                          ),
                        ):
                        Container(),
                      ],
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
