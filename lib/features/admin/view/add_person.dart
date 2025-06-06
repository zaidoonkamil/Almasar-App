import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class AddPerson extends StatelessWidget {
  const AddPerson({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController locationController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController rePasswordController = TextEditingController();

  static GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  static TextEditingController userNameController1 = TextEditingController();
  static TextEditingController phoneController1 = TextEditingController();
  static TextEditingController locationController1 = TextEditingController();
  static TextEditingController passwordController1 = TextEditingController();
  static TextEditingController rePasswordController1 = TextEditingController();

  static GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  static TextEditingController userNameController2 = TextEditingController();
  static TextEditingController phoneController2 = TextEditingController();
  static TextEditingController locationController2 = TextEditingController();
  static TextEditingController passwordController2 = TextEditingController();
  static TextEditingController rePasswordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddPersonSuccessState){
            AdminCubit.get(context).selectedImages2=[];
            userNameController.text='';
            phoneController.text='';
            locationController.text='';
            passwordController.text='';
            rePasswordController.text='';

            userNameController1.text='';
            phoneController1.text='';
            locationController1.text='';
            passwordController1.text='';
            rePasswordController1.text='';

            userNameController2.text='';
            phoneController2.text='';
            locationController2.text='';
            passwordController2.text='';
            rePasswordController2.text='';
            showToastSuccess(
              text: "تم انشاء الحساب بنجاح",
              context: context,
            );
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return DefaultTabController(
            length: 3,
            initialIndex: 2,
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
                          Tab(text: "ادمن"),
                          Tab(text: "دليفري"),
                          Tab(text: "مستخدم"),
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
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'انشاء حساب ادمن',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 70),
                                        CustomTextField(
                                          controller: userNameController,
                                          hintText: 'الاسم الثلاثي',
                                          prefixIcon: Icons.person_outline,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الاسم الثلاثي';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: phoneController,
                                          hintText: 'رقم الهاتف',
                                          prefixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل رقم الهاتف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: locationController,
                                          hintText: 'العنوان',

                                          prefixIcon: Icons.location_on_outlined,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: passwordController,
                                          hintText: 'كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                          // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب كلمة السر';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: rePasswordController,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اعد كتابة كلمة السر';
                                            }
                                          },
                                          hintText: 'اعد كتابة كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                          // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddPersonLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey.currentState!.validate()) {
                                                  if(passwordController.text == rePasswordController.text){
                                                    cubit.addPerson(
                                                      name: userNameController.text.trim(),
                                                      phone: phoneController.text.trim(),
                                                      location: locationController.text.trim(),
                                                      password: passwordController.text.trim(),
                                                      role: 'admin',
                                                      context: context,
                                                    );
                                                  }else{
                                                    print(rePasswordController.text);
                                                    print(passwordController.text);
                                                    showToastError(
                                                      text: "كلمة السر غير متطابقة",
                                                      context: context,
                                                    );
                                                  }
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
                                                  child: Text('انشاء الحساب',
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
                                    key: formKey1,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'انشاء حساب دليفري',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                            onTap:(){
                                              cubit.pickImages2();
                                            },
                                            child:
                                            cubit.selectedImages2.isEmpty?
                                            Image.asset('assets/images/Group 1171275632 (1).png'):Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(cubit.selectedImages2[0].path),
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          controller: userNameController1,
                                          hintText: 'الاسم الثلاثي',
                                          prefixIcon: Icons.person_outline,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الاسم الثلاثي';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: phoneController1,
                                          hintText: 'رقم الهاتف',
                                          prefixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل رقم الهاتف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: locationController1,
                                          hintText: 'العنوان',

                                          prefixIcon: Icons.location_on_outlined,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: passwordController1,
                                          hintText: 'كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                          // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب كلمة السر';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: rePasswordController1,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اعد كتابة كلمة السر';
                                            }
                                          },
                                          hintText: 'اعد كتابة كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                          // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddPersonLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey1.currentState!.validate()) {
                                                  if(passwordController1.text == rePasswordController1.text){
                                                    cubit.addPerson(
                                                      name: userNameController1.text.trim(),
                                                      phone: phoneController1.text.trim(),
                                                      location: locationController1.text.trim(),
                                                      password: passwordController1.text.trim(),
                                                      role: 'delivery',
                                                      context: context,
                                                    );
                                                  }else{
                                                    print(rePasswordController1.text);
                                                    print(passwordController1.text);
                                                    showToastError(
                                                      text: "كلمة السر غير متطابقة",
                                                      context: context,
                                                    );
                                                  }
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
                                                  child: Text('انشاء الحساب',
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
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'انشاء حساب مستخدم',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 70),
                                        CustomTextField(
                                          controller: userNameController2,
                                          hintText: 'الاسم الثلاثي',
                                          prefixIcon: Icons.person_outline,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الاسم الثلاثي';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                        CustomTextField(
                                          controller: phoneController2,
                                          hintText: 'رقم الهاتف',
                                          prefixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل رقم الهاتف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                        CustomTextField(
                                          controller: locationController2,
                                          hintText: 'العنوان',
                                          prefixIcon: Icons.location_on_outlined,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                        CustomTextField(
                                          controller: passwordController2,
                                          hintText: 'كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب كلمة السر';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                        CustomTextField(
                                          controller: rePasswordController2,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اعد كتابة كلمة السر';
                                            }
                                          },
                                          hintText: 'اعد كتابة كلمة السر',
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                        ),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddPersonLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey2.currentState!.validate()) {
                                                  if(passwordController2.text == rePasswordController2.text){
                                                    cubit.addPerson(
                                                      name: userNameController2.text.trim(),
                                                      phone: phoneController2.text.trim(),
                                                      location: locationController2.text.trim(),
                                                      password: passwordController2.text.trim(),
                                                      role: 'user',
                                                      context: context,
                                                    );
                                                  }else{
                                                    print(rePasswordController2.text);
                                                    print(passwordController2.text);
                                                    showToastError(
                                                      text: "كلمة السر غير متطابقة",
                                                      context: context,
                                                    );
                                                  }
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
                                                  child: Text('انشاء الحساب',
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
