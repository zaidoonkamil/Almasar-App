import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/vendor/cubit/cubit.dart';
import 'package:delivery_app/features/vendor/cubit/states.dart';
import 'package:delivery_app/features/vendor/view/my_proudcts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.idVendor, required this.product});

  final String idVendor;
  final dynamic product; // Products model

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  List<String> currentImages = [];
  List<String> removedImages = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    descriptionController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());
    currentImages = List<String>.from(widget.product.images);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => VendorCubit(),
      child: BlocConsumer<VendorCubit,VendorStates>(
        listener: (context,state){
          if (state is UpdateProductSuccessState) {
            showToastSuccess(text: 'تم تحديث المنتج بنجاح', context: context);
            // refresh products and go back
            VendorCubit.get(context).getProducts(context: context);
            navigateAndFinish(context, MyProducts());
          }
        },
        builder: (context,state){
          var cubit = VendorCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: AppBar(
                title: const Text('تعديل المنتج'),
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
                    key: EditProduct.formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // existing images
                        if (currentImages.isNotEmpty)
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: currentImages.length,
                              itemBuilder: (context,index){
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          '${url}/uploads/${currentImages[index]}',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: (){
                                          setState((){
                                            removedImages.add(currentImages[index]);
                                            currentImages.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close,color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        SizedBox(height: 20),
                        // new selected images
                        GestureDetector(
                          onTap: (){
                            cubit.pickImages();
                          },
                          child: cubit.selectedImages.isEmpty
                              ? Image.asset('assets/images/Group 1171275632 (1).png')
                              : SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cubit.selectedImages.length,
                              itemBuilder: (context,index){
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

                        const SizedBox(height: 24),

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
                          condition: state is! UpdateProductLoadingState,
                          builder: (context){
                            return GestureDetector(
                              onTap: (){
                                if (EditProduct.formKey.currentState!.validate()) {
                                  cubit.updateProduct(
                                    vendorId: widget.idVendor,
                                    productId: widget.product.id.toString(),
                                    title: titleController.text.trim(),
                                    description: descriptionController.text.trim(),
                                    price: priceController.text.trim(),
                                    removeImages: removedImages,
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
                                  child: Text('تحديث المنتج',
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
    );
  }
}
