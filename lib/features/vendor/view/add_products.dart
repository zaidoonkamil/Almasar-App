import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/vendor/cubit/states.dart';
import 'package:delivery_app/features/vendor/view/my_proudcts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../cubit/cubit.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key, required this.idVendor});

  final String idVendor;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateAndFinish(context, MyProducts());
        return true;
      },
      child: BlocProvider(
        create: (BuildContext context) => VendorCubit(),
        child: BlocConsumer<VendorCubit,VendorStates>(
          listener: (context,state){
            if(state is AddProductsSuccessState){
              VendorCubit.get(context).selectedImages=[];
              titleController.text='';
              descriptionController.text='';
              priceController.text='';
              showToastSuccess(
                text: 'تم اظافة المنتج بنجاح',
                context: context,
              );
            }
          },
          builder: (context,state){
            var cubit=VendorCubit.get(context);
            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFF5F5F5),
                appBar: AppBar(
                  title: Column(
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
                  leading: GestureDetector(
                      onTap: (){
                        navigateAndFinish(context, MyProducts());
                      },
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
                ),
                body: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 60,),
                          GestureDetector(
                            onTap: () {
                              cubit.pickImages();
                            },
                            child: cubit.selectedImages.isEmpty
                                ? Image.asset('assets/images/Group 1171275632 (1).png')
                                : SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cubit.selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipOval(
                                      child: Image.file(
                                        File(cubit.selectedImages[index].path),
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: titleController,
                            hintText: 'اسم المنتج',
                            prefixIcon: Icons.production_quantity_limits,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'رجائا اخل اسم المنتج';
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: priceController,
                            hintText: 'سعر المنتج',
                            prefixIcon: Icons.price_change_outlined,
                            keyboardType: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'رجائا اخل سعر المنتج';
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: descriptionController,
                            hintText: 'وصف المنتج',
                            prefixIcon: Icons.description_outlined,
                            keyboardType: TextInputType.text,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'رجائا اخل وصف المنتج';
                              }
                            },
                          ),
                          const SizedBox(height: 40),
                          ConditionalBuilder(
                            condition: state is !AddProductsLoadingState,
                            builder: (context){
                              return GestureDetector(
                                onTap: (){
                                  if (formKey.currentState!.validate()) {
                                      cubit.addProducts(
                                        title: titleController.text.trim(),
                                        description: descriptionController.text.trim(),
                                        price: priceController.text.trim(),
                                        context: context,
                                        idVendor: idVendor,
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
                                    child: Text('اظافة المنتج',
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
