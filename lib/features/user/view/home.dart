import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/core/widgets/custom_appbar.dart';
import 'package:delivery_app/features/user/view/orders.dart';
import 'package:delivery_app/features/user/view/products_vendor.dart';
import 'package:delivery_app/features/vendor/view/profile.dart';
import 'package:delivery_app/features/user/view/request_delivery.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/widgets/CustomSearchField.dart' show CustomSearchField;
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isValidationPassed = false;
  int currentIndex = 0;
  DateTime? lastBackPressed;
  ScrollController? scrollController;

  Timer? _debounce;
  bool showClear = false;
  UserCubit? _cubit;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    userNameController.addListener(_onSearchChanged);

    // Delay retrieving the cubit until after the first frame so BlocProvider exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _cubit = UserCubit.get(context);
        // if user typed before cubit was ready, trigger search
        final query = userNameController.text.trim();
        if (_cubit != null && query.isNotEmpty) {
          _cubit!.searchVendor(page: '1', query: query, context: context);
        }
      } catch (e) {
        _cubit = null;
      }
    });
  }

  void _onSearchChanged() {
    final cubit = _cubit;
    final text = userNameController.text;
    print('🔎 _onSearchChanged fired, text="$text", cubitReady=${cubit!=null}');
    setState(() {
      showClear = text.isNotEmpty;
    });
    if (cubit == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = userNameController.text.trim();
      print('🔎 debounce triggered for query: "$query"');
      if (query.isEmpty) {
        cubit.vendorSearchQuery = '';
        cubit.getVendor(page: '1', context: context);
      } else {
        cubit.searchVendor(page: '1', query: query, context: context);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    userNameController.removeListener(_onSearchChanged);
    userNameController.dispose();
    passwordController.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getAds(context: context)
        ..getProfile(context: context)
        ..verifyToken(context: context)
        ..getVendor(page: '1', context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);

          // Ensure _cubit is assigned when BlocProvider is ready and
          // trigger a pending search if the user typed before cubit existed.
          if (_cubit == null) {
            _cubit = cubit;
            final pendingQuery = userNameController.text.trim();
            if (pendingQuery.isNotEmpty) {
              print('🔎 triggering pending search for: "$pendingQuery"');
              _cubit!.searchVendor(page: '1', query: pendingQuery, context: context);
            }
          }

          return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                final now = DateTime.now();
                if (lastBackPressed == null || now.difference(lastBackPressed!) > Duration(seconds: 2)) {
                  lastBackPressed = now;
                  showToastInfo(
                    text: "اضغط مرة اخرى للخروج من التطبيق",
                    context: context,
                  );
                  return false;
                }
                return true;
              },
              child: Scaffold(
                backgroundColor: const Color(0xFFF2F2F7),
                body: Column(
                  children: [
                    CustomAppbar(),
                    Expanded(
                      child: ConditionalBuilder(
                          condition: cubit.profileModel != null ,
                          builder: (c){
                            return Column(
                              children: [
                                Expanded(
                                  child: NotificationListener<ScrollNotification>(
                                  onNotification: (ScrollNotification scrollInfo) {
                                    if (scrollInfo.metrics.pixels >=
                                            scrollInfo.metrics.maxScrollExtent - 50 &&
                                        cubit.vendorModel != null &&
                                        cubit.vendorModel!.paginationVendor.currentPage <
                                            cubit.vendorModel!.paginationVendor.totalPages &&
                                        !(cubit.isVendorLoadingMore || cubit.isVendorSearchLoadingMore)) {
                                      int nextPage = cubit.vendorModel!.paginationVendor.currentPage + 1;
                                      if (cubit.vendorSearchQuery.isEmpty) {
                                        cubit.getVendor(page: '$nextPage', context: context);
                                      } else {
                                        cubit.searchVendor(page: '$nextPage', query: cubit.vendorSearchQuery, context: context);
                                      }
                                    }
                                    return false;
                                  },
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    '! مرحباا مجددا',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.right,
                                                    cubit.profileModel!.name,
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 8,),
                                              Image.asset('assets/images/Group 1171275632.png'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: CustomSearchField(
                                            controller: userNameController,

                                            hintText: "بحث عن متجر...",

                                            onChanged: (value) {
                                              _onSearchChanged(); // search debounce
                                              setState(() {});
                                            },

                                            onClear: () {
                                              userNameController.clear();

                                              final cubit = _cubit;
                                              if (cubit == null) return;

                                              cubit.vendorSearchQuery = '';
                                              cubit.getVendor(page: '1', context: context);

                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 14,),
                                        Column(
                                          children: [
                                            ConditionalBuilder(
                                              condition:cubit.getAdsModel.isNotEmpty,
                                              builder:(c){
                                                return Column(
                                                  children: [
                                                    CarouselSlider(
                                                      items: cubit.getAdsModel.expand((entry) => entry.images.map((imageUrl) => Builder(
                                                        builder: (BuildContext context) {
                                                          return SizedBox(
                                                            width: double.infinity,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12.0),
                                                              child: Image.network(
                                                                "$url/uploads/$imageUrl",
                                                                fit: BoxFit.cover,
                                                                errorBuilder: (context, error, stackTrace) =>
                                                                    Icon(Icons.error),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ))).toList(),
                                                      options: CarouselOptions(
                                                        height: 180,
                                                        viewportFraction: 0.94,
                                                        enlargeCenterPage: true,
                                                        initialPage: 0,
                                                        enableInfiniteScroll: true,
                                                        reverse: true,
                                                        autoPlay: true,
                                                        autoPlayInterval: const Duration(seconds: 6),
                                                        autoPlayAnimationDuration:
                                                        const Duration(seconds: 1),
                                                        autoPlayCurve: Curves.fastOutSlowIn,
                                                        scrollDirection: Axis.horizontal,
                                                        onPageChanged: (index, reason) {
                                                          setState((){ currentIndex = index; });
                                                          cubit.slid();
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(height: 8,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: List.generate(cubit.getAdsModel.length, (index) {
                                                        return Container(
                                                          width: currentIndex == index ? 30 : 8,
                                                          height: 7.0,
                                                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: currentIndex == index
                                                                ? primaryColor
                                                                : const Color(0XFFC1D1F9),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                );
                                              },
                                              fallback: (c)=> Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 60.0),
                                                child: Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        ConditionalBuilder(
                                            condition: cubit.vendorModel != null,
                                            builder: (c){
                                              if (cubit.allVendors.isEmpty) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                                                  child: Center(
                                                    child: Text(
                                                      'لا توجد نتائج',
                                                      style: TextStyle(fontSize: 16, color: Colors.black54),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return GridView.custom(
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                                                controller: scrollController,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 4,
                                                  mainAxisSpacing: 1,
                                                  childAspectRatio: 0.8,
                                                ),
                                                childrenDelegate: SliverChildBuilderDelegate(
                                                  childCount: cubit.allVendors.length,
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        navigateTo(context, ProductsVendor(
                                                          idVendor: cubit.allVendors[index].id.toString(),
                                                          image: cubit.allVendors[index].images[0],
                                                          name: cubit.allVendors[index].name,
                                                          phone: cubit.allVendors[index].phone,
                                                        ));
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: double.maxFinite,
                                                            height: double.maxFinite,
                                                            margin: const EdgeInsets.all(4),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(6),
                                                              child: Image.network(
                                                                "$url/uploads/${cubit.allVendors[index].images[0]}",
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.all(4),
                                                                padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                                                                width: double.maxFinite,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(cubit.allVendors[index].name,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          cubit.allVendors[index].sponsorshipAmount !=0 ?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                                                margin: const EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.orange.withOpacity(0.2),
                                                                  borderRadius: BorderRadius.circular(30),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Text('موصى به',style: TextStyle(color: Colors.orange),
                                                                    textAlign: TextAlign.end,),
                                                                    Image.asset('assets/images/solar_fire-bold.png'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ):Container(),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            fallback: (c)=>Center(child: CircularProgress())),
                                        SizedBox(height: 30,),
                                        if (cubit.isVendorLoadingMore || cubit.isVendorSearchLoadingMore)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: CircularProgressIndicator()),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                ),
                              ],
                            );
                          },
                          fallback: (c)=>Center(child: CircularProgress())),
                    ),
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
