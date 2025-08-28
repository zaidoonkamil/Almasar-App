import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/core/styles/themes.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'details.dart';

class ProductsVendor extends StatelessWidget {
  const ProductsVendor({super.key, required this.idVendor,required this.image, required this.name, required this.phone});

  final String image;
  final String name;
  final String phone;
  final String idVendor;
  static ScrollController? scrollController;
  static TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getProductsVendor(page: '1', context: context, id: idVendor),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){
          if(state is DeleteCartSuccessState){
            navigateBack(context);
          }
        },
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                  CustomAppbarBack(),
                  ConditionalBuilder(
                      condition: cubit.productsVendorModel != null ,
                      builder: (c){
                        return ConditionalBuilder(
                            condition: cubit.productsVendorModel!.products.isNotEmpty,
                            builder: (c){
                              return Expanded(
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 16,),
                                      Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.network(
                                            '$url/uploads/$image',
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6,),
                                      Text(name,style: TextStyle(fontSize: 18),),
                                      SizedBox(height: 16,),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        width: double.maxFinite,
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 12,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                            onTap: (){
                                              if(searchController.text.isNotEmpty){
                                                searchController.text.trim();
                                                cubit.getProductsVendorSearch(
                                                    title: searchController.text,
                                                    page: '1',
                                                    id: idVendor,
                                                    context: context);
                                              }else{
                                                cubit.getProductsVendor(page: '1', context: context, id: idVendor);
                                              }
                                            },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                                            child: Text('بحث',
                                              style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                          ),
                                        ),
                                      ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: CustomTextField(
                                                controller: searchController,
                                                hintText: 'بحث',
                                                prefixIcon: Icons.search,
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16,),
                                      GridView.custom(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                                        controller: scrollController,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 7,
                                          mainAxisSpacing: 7,
                                          childAspectRatio: 0.65,
                                        ),
                                        childrenDelegate: SliverChildBuilderDelegate(
                                          childCount: cubit.productsVendorModel!.products.length,
                                              (context, index) {
                                            int number = int.parse(cubit.productsVendorModel!.products[index].price.toString());
                                            DateTime dateTime = DateTime.parse(cubit.productsVendorModel!.products[index].createdAt.toString());
                                            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                                            return GestureDetector(
                                              onTap: () {
                                                navigateTo(context, Details(
                                                  id: cubit.productsVendorModel!.products[index].id.toString(),
                                                  tittle: cubit.productsVendorModel!.products[index].title.toString(),
                                                  description: cubit.productsVendorModel!.products[index].description.toString(),
                                                  price: cubit.productsVendorModel!.products[index].price.toString(),
                                                  images: cubit.productsVendorModel!.products[index].images,
                                                  formattedDate: formattedDate,
                                                ));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: double.maxFinite,
                                                          height: 170,
                                                          margin: const EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: Image.network(
                                                              "$url/uploads/${cubit.productsVendorModel!.products[index].images[0]}",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Expanded(
                                                                child: Text(cubit.productsVendorModel!.products[index].title,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(color: Colors.black,fontSize: 16),),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              margin: const EdgeInsets.all(4),
                                                              padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                                                              width: double.maxFinite,
                                                              decoration: BoxDecoration(
                                                                color: primaryColor.withOpacity(0.7),
                                                                borderRadius: BorderRadius.circular(6),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text('د.ع',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: Colors.white,fontSize: 16),),
                                                                  SizedBox(width: 2,),
                                                                  Text(NumberFormat('#,###').format(number).toString(),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: Colors.white,fontSize: 16),),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    adminOrUser == 'admin'? GestureDetector(
                                                      onTap: (){
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              backgroundColor:  Color(0xFFF5F5F8),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              title: Column(
                                                                children: [
                                                                  Text("هل حقا ترغب في حذف المنتج ؟",
                                                                    style: TextStyle(fontSize: 18),
                                                                    textAlign: TextAlign.center,),
                                                                ],
                                                              ),
                                                              content: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("إلغاء",style: TextStyle(color: Colors.red),),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.red,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      cubit.deleteProductsInOfVendor(context: context,
                                                                          vendorId: idVendor,
                                                                          productId:  cubit.productsVendorModel!.products[index].id.toString());
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
                                                        margin: EdgeInsets.all(20),
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(30),
                                                          color: Colors.red.withOpacity(0.2),
                                                        ),
                                                        child: Icon(Icons.delete,color: Colors.red,),
                                                      ),
                                                    ):Container(),

                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              );
                            },
                            fallback: (c)=>Expanded(
                              child: Center(child: Text('لا يوجد بيانات ليتم عرضها')),
                            )
                        );
                      },
                      fallback: (c)=>Center(child: CircularProgress())),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
