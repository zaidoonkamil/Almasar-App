import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/custom_appbar.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/view/login.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class RequestDelivery extends StatelessWidget {
  const RequestDelivery({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController locationController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController deliveryFeeController = TextEditingController();
  static TextEditingController noteController = TextEditingController();
  static bool isValidationPassed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit(),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){
          if(state is AddOrderSuccessState){
            phoneController.text='';
            locationController.text='';
            priceController.text='';
            deliveryFeeController.text='';
            noteController.text='';
            showToastSuccess(text: 'تم ادراج الطلب بنجاح', context: context);
          }
        },
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                 adminOrUser == 'vendor'? CustomAppbarBack():CustomAppbar(),
                  token !=''? Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'طلب مندوب',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Text(
                                        'معلومــــات المستلم',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
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
                                controller: priceController,
                                hintText: 'مبلغ الطلبية',
                                prefixIcon: Icons.price_check,
                                keyboardType: TextInputType.number,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'رجائا اخل مبلغ الطلبية';
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: deliveryFeeController,
                                hintText: 'مبلغ التوصيل',
                                prefixIcon: Icons.delivery_dining,
                                keyboardType: TextInputType.number,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'رجائا اخل مبلغ التوصيل';
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: noteController,
                                hintText: 'ملاحظات (اختياري)',
                                prefixIcon: Icons.note_alt_outlined,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 60),
                              ConditionalBuilder(
                                  condition: state is !AddOrderLoadingState,
                                  builder: (c){
                                    return GestureDetector(
                                      onTap: (){
                                        if (formKey.currentState!.validate()) {
                                          cubit.addOrder(
                                            address: locationController.text,
                                            phone: phoneController.text,
                                            orderAmount: priceController.text,
                                            deliveryFee: deliveryFeeController.text,
                                            notes: noteController.text,
                                            context: context,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
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
                                          child: Text('طلب مندوب',
                                            style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                        ),
                                      ),
                                    );
                                  },
                                  fallback: (c)=>Center(child: CircularProgressIndicator())),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ):
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
          );
        },
      ),
    );
  }
}
