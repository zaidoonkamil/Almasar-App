import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/admin/navigation_bar_admin.dart';
import 'package:delivery_app/features/delivery/view/all_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class DetailsPerson extends StatelessWidget {
  const DetailsPerson({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.role,
    required this.createdAt,
    required this.sponsorshipAmount,
  });

  final String id;
  final String name;
  final String phone;
  final String location;
  final String role;
  final String createdAt;
  final String sponsorshipAmount;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getLatAndLong(context: context, id: id)
        ..getFirstCall(sponsorshipAmount: sponsorshipAmount),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if(state is DeleteUserSuccessState){
            navigateAndFinish(context, BottomNavBarAdmin(initialIndex: 2,));
          }
        },
        builder: (context, state) {
          var cubit=AdminCubit.get(context);
          DateTime date = DateTime.parse(createdAt);
          String formattedDate = "${date.year}-${date.month}-${date.day}";
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 14),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColor,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Image.asset('assets/images/fluent_person-16-regular.png'),
                                  SizedBox(height: 10,),
                                  Image.asset('assets/images/solar_phone-outline (3).png'),
                                  SizedBox(height: 10,),
                                  Image.asset('assets/images/mingcute_location-line (2).png'),
                                  SizedBox(height: 10,),
                                  Image.asset('assets/images/f7_person-2.png'),
                                  SizedBox(height: 10,),
                                  Image.asset('assets/images/tabler_clock.png'),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(name,style: TextStyle(fontSize: 18),),
                                  SizedBox(height: 10,),
                                  Text(phone,style: TextStyle(fontSize: 18),),
                                  SizedBox(height: 10,),
                                  Text(location,style: TextStyle(fontSize: 18),),
                                  SizedBox(height: 10,),
                                  Text(role,style: TextStyle(fontSize: 18),),
                                  SizedBox(height: 10,),
                                  Text(formattedDate,style: TextStyle(fontSize: 18),),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(':الاسم',style: TextStyle(fontSize: 17),),
                                  SizedBox(height: 10,),
                                  Text(':الهاتف',style: TextStyle(fontSize: 17),),
                                  SizedBox(height: 10,),
                                  Text(':الموقع',style: TextStyle(fontSize: 17),),
                                  SizedBox(height: 10,),
                                  Text(':الصلاحياة',style: TextStyle(fontSize: 17),),
                                  SizedBox(height: 10,),
                                  Text(':تاريخ الانشاء',style: TextStyle(fontSize: 17),),
                                ],
                              ),
                            ],
                          ),
                         role=='delivery'? Column(
                            children: [
                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: (){
                                  cubit.openMap(context: context);
                                },
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                      borderRadius:  BorderRadius.circular(8),
                                      color: primaryColor
                                  ),
                                  child: Center(
                                    child: Text('موقع الدلفري',
                                      style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, AllOrdersDelivery(id: id));
                                },
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                      borderRadius:  BorderRadius.circular(8),
                                      color: primaryColor
                                  ),
                                  child: Center(
                                    child: Text('كل الطلبات',
                                      style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    role == 'vendor'? Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ConditionalBuilder(
                                  condition: state is !SponsorshipVendorLoadingState,
                                  builder: (context){
                                    return GestureDetector(
                                      onTap: (){
                                        if(cubit.userNameController.text != ''){
                                          cubit.sponsorshipVendor(context: context, id: id, sponsorshipAmount: cubit.userNameController.text.trim());
                                        }else{
                                          showToastError(text: 'رجائا ادخل قيمة', context: context);
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
                                          child: Text('تعديل',
                                            style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                        ),
                                      ),
                                    );
                                  },
                                  fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                ),
                                SizedBox(width: 8,),
                                Expanded(
                                  child: CustomTextField(
                                    controller: cubit.userNameController,
                                    hintText: 'قيمة الاعلان',
                                    prefixIcon: Icons.ads_click,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ):Container(),
                    ConditionalBuilder(
                      condition: state is !DeleteUserLoadingState,
                      builder: (context){
                        return GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Column(
                                    children: [
                                      Text("هل حقا ترغب في حذف المستخدم ؟",
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,),
                                      Text("سوف يشمل ذلك حذف جميع بيانات المستخدم هذا",
                                        style: TextStyle(fontSize: 16,color: Colors.grey),
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
                                        child: Text("إلغاء",style: TextStyle(color: primaryColor),),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          cubit.deleteUser(context: context, id: id);
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
                            margin: EdgeInsets.symmetric(horizontal: 20),
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
                              child: Text('حذف المستخدم',
                                style: TextStyle(color: Colors.white,fontSize: 18 ),),
                            ),
                          ),
                        );
                      },
                      fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                    ),
                    SizedBox(height: 20),
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
