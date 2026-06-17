import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/features/admin/navigation_bar_admin.dart';
import 'package:delivery_app/features/auth/view/register.dart';
import 'package:delivery_app/features/delivery/navigation_bar_Delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivery_app/core/ navigation/navigation.dart';
import 'package:delivery_app/core/network/local/cache_helper.dart';
import 'package:delivery_app/core/styles/themes.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/custom_text_field.dart';
import '../../user/navigation_bar_user.dart';
import '../../vendor/view/home.dart';
import 'package:delivery_app/features/auth/cubit/cubit.dart';
import 'package:delivery_app/features/auth/cubit/states.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isValidationPassed = false;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'token',
              value: AuthCubit.get(context).token,
            ).then((value) {
              CacheHelper.saveData(
                key: 'id',
                value: AuthCubit.get(context).id,
              ).then((value) {
                CacheHelper.saveData(
                  key: 'role',
                  value: AuthCubit.get(context).role,
                ).then((value) {
                  token = AuthCubit.get(context).token.toString();
                  id = AuthCubit.get(context).id.toString();
                  adminOrUser = AuthCubit.get(context).role.toString();
                  if (adminOrUser == 'admin') {
                    navigateAndFinish(context, BottomNavBarAdmin());
                  } else if (adminOrUser == 'delivery') {
                    navigateAndFinish(context, BottomNavBarDelivery());
                  } else if (adminOrUser == 'vendor') {
                    navigateAndFinish(context, HomeVendor());
                  } else {
                    navigateAndFinish(context, BottomNavBarUser());
                  }
                });
              });
            });
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  navigateBack(context);
                                } else {
                                  navigateAndFinish(
                                    context,
                                    const BottomNavBarUser(),
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 26,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        Image.asset('assets/images/logo.png', height: 100),
                        const SizedBox(height: 12),
                        const Text(
                          'شركة المسار',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'للتوصيل الداخلي السريع',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 70),
                        CustomTextField(
                          controller: userNameController,
                          hintText: 'رقم الهاتف',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              cubit.validation();
                              return 'رجائا اخل رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'كلمة السر',
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              cubit.validation();
                              return 'رجائا اكتب كلمة السر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 60),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.signIn(
                                    phone: userNameController.text.trim(),
                                    password: passwordController.text.trim(),
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
                                  borderRadius: BorderRadius.circular(12),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          fallback:
                              (c) => CircularProgressIndicator(
                                color: primaryColor,
                              ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateTo(context, Register());
                              },
                              child: const Text(
                                'انشاء حساب ',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text("لا تمتلك حساب ؟ "),
                          ],
                        ),
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
