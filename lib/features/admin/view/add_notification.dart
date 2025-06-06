import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class AddNotification extends StatelessWidget {
  const AddNotification({super.key});

  static GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  static GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController tittleController2 = TextEditingController();
  static TextEditingController descController2 = TextEditingController();
  static TextEditingController roleController2 = TextEditingController();
  static TextEditingController tittleController1 = TextEditingController();
  static TextEditingController descController1 = TextEditingController();
  static List<String> role=['user','vendor','admin','delivery',];


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddNotificationSuccessState){
            tittleController2.text='';
            descController2.text='';
            roleController2.text='';

            tittleController1.text='';
            descController1.text='';

            showToastSuccess(text: "تمت عملية ارسال الاشعار بنجاح", context: context);
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFF5F5F5),
                body: Column(
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
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ButtonsTabBar(
                        radius: 8,
                        contentPadding: EdgeInsets.symmetric(horizontal: 27),
                        borderWidth: 1,
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        splashColor: primaryColor,
                        unselectedLabelStyle: TextStyle(color: Colors.grey,fontSize: 16),
                        unselectedBackgroundColor: Colors.white,
                        unselectedBorderColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                        height: 56,
                        tabs:[
                          Tab(text: "كل المستخدمين"),
                          Tab(text: "مجموعة مخصصة"),
                        ],),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Form(
                                    key: formKey1,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 40,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'انشاء اشعار للكل',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        CustomTextField(
                                          controller: tittleController1,
                                          hintText: 'العنوان',
                                          prefixIcon: Icons.note_alt_outlined,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: descController1,
                                          hintText: 'الوصف',
                                          maxLines: 8,
                                          prefixIcon: Icons.note_alt,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الوصف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddNotificationLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey1.currentState!.validate()) {
                                                  cubit.addNotification(
                                                      context: context,
                                                      title: tittleController1.text.trim(),
                                                      desc: descController1.text.trim(),
                                                    role: ''
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
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
                                                    borderRadius:  BorderRadius.circular(12),
                                                    color: primaryColor
                                                ),
                                                child: Center(
                                                  child: Text('ارسال الاشعار',
                                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                ),
                                              ),
                                            );
                                          },
                                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Form(
                                    key: formKey2,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 40,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'انشاء اشعار مخصص',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        CustomTextField(
                                          controller: tittleController2,
                                          hintText: 'العنوان',
                                          prefixIcon: Icons.note_alt_outlined,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: descController2,
                                          hintText: 'الوصف',
                                          maxLines: 8,
                                          prefixIcon: Icons.note_alt,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الوصف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: roleController2,
                                          hintText: 'ارسال الى',
                                          keyboardType: TextInputType.none,
                                          onTap: (){
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      Text("اختر لمن تريد الارسال",style: TextStyle(color: primaryColor),),
                                                      SizedBox(height: 12),
                                                      Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                      SizedBox(height: 12),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: role.length,
                                                            itemBuilder:(c,i){
                                                          return GestureDetector(
                                                            onTap: (){
                                                              roleController2.text=role[i];
                                                              navigateBack(context);
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Text(role[i],style: TextStyle(fontSize: 16),),
                                                                SizedBox(height: 12),
                                                                Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                                SizedBox(height: 12),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                          },
                                          prefixIcon: Icons.person_outline,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل ارسال الى';
                                            }
                                          },
                                        ),

                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddNotificationLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey2.currentState!.validate()) {
                                                  cubit.addNotification(
                                                      context: context,
                                                      title: tittleController2.text.trim(),
                                                      desc: descController2.text.trim(),
                                                      role: roleController2.text.trim());
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
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
                                                    borderRadius:  BorderRadius.circular(12),
                                                    color: primaryColor
                                                ),
                                                child: Center(
                                                  child: Text('ارسال الاشعار',
                                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                ),
                                              ),
                                            );
                                          },
                                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
