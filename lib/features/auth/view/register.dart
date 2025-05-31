import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController locationController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController rePasswordController = TextEditingController();
  static GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  static TextEditingController userNameController2 = TextEditingController();
  static TextEditingController phoneController2 = TextEditingController();
  static TextEditingController locationController2 = TextEditingController();
  static TextEditingController passwordController2 = TextEditingController();
  static TextEditingController rePasswordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if(state is SignUpSuccessState){
            userNameController.text='';
            phoneController.text='';
            locationController.text='';
            passwordController.text='';
            rePasswordController.text='';

            AuthCubit.get(context).selectedImages=[];
            userNameController2.text='';
            phoneController2.text='';
            locationController2.text='';
            passwordController2.text='';
            rePasswordController2.text='';
            showToastSuccess(
              text: "تم انشاء الحساب بنجاح",
              context: context,
            );
            navigateAndFinish(context, Login());
          }
        },
        builder: (context,state){
          var cubit=AuthCubit.get(context);
          return DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFF5F5F5),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: (){
                                navigateBack(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded,size: 26,)),
                          const Text(
                            'انشاء حساب',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonsTabBar(
                              radius: 8,
                              contentPadding: EdgeInsets.symmetric(horizontal: 22),
                              borderWidth: 1,
                              physics: AlwaysScrollableScrollPhysics(),
                              decoration: BoxDecoration(color: Color(0XFF212844),),
                              splashColor: Colors.indigo,
                              unselectedLabelStyle: TextStyle(color: Colors.grey,fontSize: 16),
                              unselectedBackgroundColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              height: 56,
                              tabs:[
                                Tab(text: "كمستخدم"),
                                Tab(text: "كتاجر"),
                              ],),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                            children: [
                          SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 70),
                                  CustomTextField(
                                    controller: userNameController,
                                    hintText: 'الاسم الثلاثي',
                                    prefixIcon: Icons.person_outline,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
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
                                        cubit.validation();
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
                                        cubit.validation();
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
                                        cubit.validation();
                                        return 'رجائا اكتب كلمة السر';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: rePasswordController,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
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
                                    condition: state is !SignUpLoadingState,
                                    builder: (context){
                                      return GestureDetector(
                                        onTap: (){
                                          if (formKey.currentState!.validate()) {
                                            if(passwordController.text == rePasswordController.text){
                                              cubit.signUp(
                                                name: userNameController.text.trim(),
                                                phone: phoneController.text.trim(),
                                                location: locationController.text.trim(),
                                                password: passwordController.text.trim(),
                                                role: 'user',
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          navigateBack(context);
                                        },
                                        child: const Text(
                                          'تسجيل الدخول ',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Text("امتلك حساب ؟ "),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Form(
                              key: formKey2,
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  GestureDetector(
                                      onTap:(){
                                        cubit.pickImages();
                                      },
                                      child:
                                      cubit.selectedImages.isEmpty?
                                      Image.asset('assets/images/Group 1171275632 (1).png'):Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipOval(
                                          child: Image.file(
                                            File(cubit.selectedImages[0].path),
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    controller: userNameController2,
                                    hintText: 'الاسم الثلاثي',
                                    prefixIcon: Icons.person_outline,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
                                        return 'رجائا اخل الاسم الثلاثي';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: phoneController2,
                                    hintText: 'رقم الهاتف',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
                                        return 'رجائا اخل رقم الهاتف';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: locationController2,
                                    hintText: 'العنوان',

                                    prefixIcon: Icons.location_on_outlined,
                                    keyboardType: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
                                        return 'رجائا اخل العنوان';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: passwordController2,
                                    hintText: 'كلمة السر',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
                                        return 'رجائا اكتب كلمة السر';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: rePasswordController2,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        cubit.validation();
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
                                    condition: state is !SignUpLoadingState,
                                    builder: (context){
                                      return GestureDetector(
                                        onTap: (){
                                          if (formKey2.currentState!.validate()) {
                                            if(passwordController2.text == rePasswordController2.text){
                                              cubit.signUp(
                                                name: userNameController2.text.trim(),
                                                phone: phoneController2.text.trim(),
                                                location: locationController2.text.trim(),
                                                password: passwordController2.text.trim(),
                                                role: 'vendor',
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          navigateBack(context);
                                        },
                                        child: const Text(
                                          'تسجيل الدخول ',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Text("امتلك حساب ؟ "),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
