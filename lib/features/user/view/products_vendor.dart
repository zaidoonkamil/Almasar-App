import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/core/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'details.dart';

class ProductsVendor extends StatelessWidget {
  const ProductsVendor({super.key, required this.idVendor, required this.image, required this.name, required this.phone});

  final String image;
  final String name;
  final String phone;
  final String idVendor;
  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getProductsVendor(page: '1', context: context, id: idVendor),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            navigateBack(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                        Container(width: 40,)
                      ],
                    ),
                  ),
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
                                                if (index == cubit.productsVendorModel!.products.length - 1 && !cubit.isLastPageProductsVendor) {
                                                  cubit.getProductsVendor(page: (cubit.currentPageProductsVendor + 1).toString(), context: context, id: idVendor);
                                                }
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
                                                child: Column(
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
