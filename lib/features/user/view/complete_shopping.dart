import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/user/navigation_bar_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/cubit/cubit.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class CompleteShopping extends StatelessWidget {
  const CompleteShopping({super.key, required this.products, required this.idVendor});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController locationController = TextEditingController();
  static TextEditingController noteController = TextEditingController();
  final List<Map<String, dynamic>> products;
  final String idVendor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit(),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){
          if(state is AddOrderCartSuccessState){
            noteController.text='';
            phoneController.text='';
            locationController.text='';
            showToastSuccess(
              text: "تمت عملية الطلب بنجاح",
              context: context,
            );
            navigateAndFinish(context, BottomNavBarUser());
          }
        },
        builder: (context,state){
          var cubit = UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 62,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text('انهاء الطلب',style: TextStyle(fontSize: 20),),
                                      SizedBox(width: 4,),
                                      GestureDetector(
                                          onTap: (){
                                            navigateBack(context);
                                          },
                                          child: Icon(Icons.arrow_forward_ios_outlined)),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('الدفع',style: TextStyle(fontSize: 20,color: Colors.grey),),
                              ],
                            ),
                          ),
                          SizedBox(height: 12,),
                          Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white
                            ),
                            child: Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0XFFF0F0F0)
                                ),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: primaryColor
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(': الدفـــــــــــــــــع'),
                                        Text('نقدا عند الاستلام',style: TextStyle(color: Colors.grey),),
                                      ],
                                    ),
                                  ],
                                ),
                            ),
                          ),
                          SizedBox(height: 16,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                CustomTextField(
                                  controller: phoneController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا ادخل رقم الهاتف';
                                    }
                                  },
                                  hintText: 'ادخل رقم الهاتف',
                                  prefixIcon: Icons.phone_outlined,
                                ),
                                SizedBox(height: 16,),
                                CustomTextField(
                                  controller: locationController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا ادخل العنوان بالتفصيل';
                                    }
                                  },
                                  hintText: 'ادخل العنوان بالتفصيل',
                                  prefixIcon: Icons.location_on_outlined,
                                ),
                                SizedBox(height: 16,),
                                CustomTextField(
                                  controller: noteController,
                                  hintText: 'ادخل ملاحضة(اختياري)',
                                  prefixIcon: Icons.person_outlined,
                                ),
                                SizedBox(height: 12,),
                              ],
                            ),
                          ),
                          SizedBox(height: 100,),
                        ],
                      ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical:18 ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if (formKey.currentState!.validate()) {
                                    cubit.addOrderCart(
                                        notes: noteController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        address: locationController.text.trim(),
                                        products: products,
                                      context: context,
                                      idVendor: idVendor,
                                    );
                                  }
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
                                      ConditionalBuilder(
                                          condition: state is !AddOrderLoadingState,
                                          builder: (c)=>Text('التاكيد',
                                            style: TextStyle(color: Colors.white,fontSize: 16),
                                          ),
                                          fallback: (c)=>CircularProgress(color: Colors.white,)
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
              ),
            ),
          );
        },
      ),
    );
  }
}
