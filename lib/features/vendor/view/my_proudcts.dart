import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/features/vendor/view/add_products.dart';
import 'package:delivery_app/features/vendor/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateAndFinish(context, HomeVendor());
        return true;
      },
      child: BlocProvider(
        create: (BuildContext context) =>
        VendorCubit()..getProducts(context: context),
        child: BlocConsumer<VendorCubit,VendorStates>(
          listener: (context,state){},
          builder: (context,state){
            var cubit=VendorCubit.get(context);
            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFF2F2F7),
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
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                          onTap: (){
                            navigateTo(context, AddProducts());
                          },
                          child: Icon(Icons.add,color: Colors.black,size: 28,)),
                    )
                  ],
                  leading: GestureDetector(
                      onTap: (){
                        navigateAndFinish(context, HomeVendor());
                      },
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
                ),
                body: ConditionalBuilder(
                    condition: cubit.getProductsModel != null ,
                    builder: (c){
                      return Column(
                        children: [
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cubit.getProductsModel!.products.length,
                                      itemBuilder:(context,index){
                                        int number = int.parse(cubit.getProductsModel!.products[index].price.toString());
                                        DateTime dateTime = DateTime.parse(cubit.getProductsModel!.products[index].createdAt.toString());
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

                                        return Container(
                                          padding: EdgeInsets.all(12),
                                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.white
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(width: 12,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                cubit.getProductsModel!.products[index].title.toString(),
                                                            textAlign: TextAlign.end,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,)),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text('د.ع',style: TextStyle(color: primaryColor),),
                                                            SizedBox(width: 4,),
                                                            Text(NumberFormat('#,###').format(number).toString(),style: TextStyle(fontSize: 16),),
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 12,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        width: 74,
                                                        height: 74,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(6.0),
                                                          child: Image.network(
                                                            '$url/uploads/${cubit.getProductsModel!.products[index].images[0].toString()}',
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(' ${index+1}#',style: TextStyle(fontSize: 16),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4,),
                                              Container(width: double.maxFinite,height:1,color: Colors.grey,),
                                              SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(formattedDate),
                                                  SizedBox(width: 4,),
                                                  Image.asset('assets/images/solar_calendar-broken (1).png',width: 20,height: 20,),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(child: Text(
                                                    cubit.getProductsModel!.products[index].description.toString(),
                                                    textAlign: TextAlign.end,
                                                  ),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),

                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    fallback: (c)=>Center(child: CircularProgress())),

              ),
            );
          },
        ),
      ),
    );
  }
}
