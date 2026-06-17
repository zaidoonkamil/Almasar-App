import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:delivery_app/core/ navigation/navigation.dart';
import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/core/styles/themes.dart';
import 'package:delivery_app/core/widgets/custom_appbar.dart';
import 'package:delivery_app/features/auth/view/login.dart';
import 'package:delivery_app/features/user/cubit/cubit.dart';
import 'package:delivery_app/features/user/cubit/states.dart';
import 'package:delivery_app/features/user/model/GetOrder.dart';
import 'package:delivery_app/features/user/view/chat_screen.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    if (token == '') {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F8),
          body: Column(
            children: [
              CustomAppbar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
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
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
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
    }

    return BlocProvider(
      create:
          (BuildContext context) =>
              UserCubit()..getOrder(context: context, page: '1'),
      child: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
              body: Column(
                children: [
                  CustomAppbar(),
                  token != ''
                      ? Expanded(
                        child: ConditionalBuilder(
                          condition: cubit.orderModel != null,
                          builder: (c) {
                            return ConditionalBuilder(
                              condition: cubit.orders.isNotEmpty,
                              builder: (c) {
                                return Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'تقرير الطلبيات',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Expanded(
                                      child: NotificationListener<
                                        ScrollNotification
                                      >(
                                        onNotification: (
                                          ScrollNotification scrollInfo,
                                        ) {
                                          if (scrollInfo
                                                  is ScrollUpdateNotification &&
                                              scrollInfo.metrics.pixels >=
                                                  scrollInfo
                                                          .metrics
                                                          .maxScrollExtent -
                                                      50 &&
                                              !cubit.isLastPage &&
                                              state is! GetOrderLoadingState) {
                                            cubit.getOrder(
                                              page:
                                                  (cubit.currentPage + 1)
                                                      .toString(),
                                              context: context,
                                            );
                                          }
                                          return false;
                                        },
                                        child: ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemCount: cubit.orders.length,
                                          itemBuilder: (context, index) {
                                            final order = cubit.orders[index];
                                            DateTime dateTime = DateTime.parse(
                                              order.createdAt.toString(),
                                            );
                                            String formattedDate = DateFormat(
                                              'yyyy/M/d',
                                            ).format(dateTime);
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 22,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black54
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  14,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "${index + 1}",
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            Text(
                                                              " طلب #",
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      width: double.maxFinite,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            order.status ==
                                                                    'تم الاستلام'
                                                                ? Colors.blue
                                                                    .withOpacity(
                                                                      0.1,
                                                                    )
                                                                : order.status ==
                                                                    'تم التسليم'
                                                                ? Colors.green
                                                                    .withOpacity(
                                                                      0.1,
                                                                    )
                                                                : order.status ==
                                                                    'استرجاع الطلب'
                                                                ? Colors.red
                                                                    .withOpacity(
                                                                      0.1,
                                                                    )
                                                                : Colors.orange
                                                                    .withOpacity(
                                                                      0.2,
                                                                    ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        order.status,
                                                        style: TextStyle(
                                                          color:
                                                              order.status ==
                                                                      'تم الاستلام'
                                                                  ? Colors.blue
                                                                  : order.status ==
                                                                      'تم التسليم'
                                                                  ? Colors.green
                                                                  : order.status ==
                                                                      'استرجاع الطلب'
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .orange,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          order.vendor?.name ??
                                                              "متجر غير معروف",
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .store_mall_directory_outlined,
                                                          color: primaryColor,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          formattedDate,
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              order.phone,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 6,
                                                            ),
                                                            const Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            order.address,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        const Icon(
                                                          Icons.location_on,
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        order.items != null &&
                                                                order
                                                                    .items!
                                                                    .isNotEmpty
                                                            ? Container()
                                                            : Row(
                                                              children: [
                                                                Text(
                                                                  'د.ع ',
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  order
                                                                      .deliveryFee
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .delivery_dining,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              ],
                                                            ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              ' د.ع ',
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              order.orderAmount
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 6,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .price_change_outlined,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          ': ملاحظات',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: const TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        order.notes == ''
                                                            ? Expanded(
                                                              child: Text(
                                                                'لا يوجد',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            )
                                                            : Expanded(
                                                              child: Text(
                                                                order.notes,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                    order.items != null &&
                                                            order
                                                                .items!
                                                                .isNotEmpty
                                                        ? Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Container(
                                                              width:
                                                                  double
                                                                      .maxFinite,
                                                              height: 2,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            SizedBox(
                                                              height: 90,
                                                              child: ListView.builder(
                                                                physics:
                                                                    AlwaysScrollableScrollPhysics(),
                                                                itemCount:
                                                                    order
                                                                        .items
                                                                        ?.length,
                                                                itemBuilder: (
                                                                  context,
                                                                  itemIndex,
                                                                ) {
                                                                  int
                                                                  number = int.parse(
                                                                    order
                                                                        .items![itemIndex]
                                                                        .product
                                                                        .price
                                                                        .toString(),
                                                                  );
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                          Expanded(
                                                                            child: Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.end,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      order.items![itemIndex].product.title.toString(),
                                                                                      maxLines:
                                                                                          1,
                                                                                      overflow:
                                                                                          TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height:
                                                                                      4,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      'د.ع',
                                                                                      style: TextStyle(
                                                                                        color:
                                                                                            primaryColor,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width:
                                                                                          4,
                                                                                    ),
                                                                                    Text(
                                                                                      NumberFormat(
                                                                                            '#,###',
                                                                                          )
                                                                                          .format(
                                                                                            number,
                                                                                          )
                                                                                          .toString(),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                64,
                                                                            height:
                                                                                64,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                6,
                                                                              ),
                                                                            ),
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                6.0,
                                                                              ),
                                                                              child: Image.network(
                                                                                '$url/uploads/${order.items![itemIndex].product.images[0].toString()}',
                                                                                fit:
                                                                                    BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                '${itemIndex + 1}',
                                                                                style: TextStyle(
                                                                                  color:
                                                                                      primaryColor,
                                                                                  fontSize:
                                                                                      14,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width:
                                                                                    2,
                                                                              ),
                                                                              Text(
                                                                                '#',
                                                                                style: TextStyle(
                                                                                  fontSize:
                                                                                      18,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                        : const SizedBox(
                                                          height: 12,
                                                        ),
                                                     const SizedBox(height: 12),
                                                     Row(
                                                       children: [
                                                         if (order.assignedDeliveryId != null) ...[
                                                           Expanded(
                                                             child: OutlinedButton.icon(
                                                               onPressed: () {
                                                                 navigateTo(
                                                                   context,
                                                                   ChatScreen(
                                                                     orderId: order.id,
                                                                     otherUserId: order.assignedDeliveryId!,
                                                                     otherUserName: order.delivery?.name ?? 'المندوب',
                                                                     otherUserRole: 'delivery',
                                                                     orderStatus: order.status,
                                                                   ),
                                                                 );
                                                               },
                                                               icon: const Icon(Icons.chat_outlined, size: 16, color: primaryColor),
                                                               label: const Text(
                                                                 'دردشة المندوب',
                                                                 style: TextStyle(
                                                                   fontSize: 12,
                                                                   fontFamily: 'cairo',
                                                                   fontWeight: FontWeight.bold,
                                                                   color: primaryColor,
                                                                 ),
                                                               ),
                                                               style: OutlinedButton.styleFrom(
                                                                 side: const BorderSide(color: primaryColor),
                                                                 padding: const EdgeInsets.symmetric(vertical: 8),
                                                                 shape: RoundedRectangleBorder(
                                                                   borderRadius: BorderRadius.circular(8),
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                           const SizedBox(width: 8),
                                                         ],
                                                         Expanded(
                                                           child: ElevatedButton.icon(
                                                             onPressed: () {
                                                               navigateTo(
                                                                 context,
                                                                 ChatScreen(
                                                                   orderId: order.id,
                                                                   otherUserId: 1, // Default Admin ID
                                                                   otherUserName: 'الدعم الفني',
                                                                   otherUserRole: 'admin',
                                                                   orderStatus: order.status,
                                                                 ),
                                                               );
                                                             },
                                                             icon: const Icon(Icons.support_agent_outlined, size: 16, color: Colors.white),
                                                             label: const Text(
                                                               'تواصل مع الإدارة',
                                                               style: TextStyle(
                                                                 fontSize: 12,
                                                                 fontFamily: 'cairo',
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Colors.white,
                                                               ),
                                                               overflow: TextOverflow.ellipsis,
                                                             ),
                                                             style: ElevatedButton.styleFrom(
                                                               backgroundColor: Colors.blueAccent,
                                                               elevation: 0,
                                                               padding: const EdgeInsets.symmetric(vertical: 8),
                                                               shape: RoundedRectangleBorder(
                                                                 borderRadius: BorderRadius.circular(8),
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                    if (order.status ==
                                                            'تم التسليم' &&
                                                        order.assignedDeliveryId !=
                                                            null) ...[
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Container(
                                                        width: double.maxFinite,
                                                        height: 1,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          order.rating == null
                                                              ? ElevatedButton.icon(
                                                                onPressed: () {
                                                                  _showRatingDialog(
                                                                    context,
                                                                    cubit,
                                                                    order,
                                                                  );
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .star_border,
                                                                  size: 18,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                label: const Text(
                                                                  'تقييم المندوب',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'cairo',
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      primaryColor,
                                                                  elevation: 0,
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            14,
                                                                        vertical:
                                                                            8,
                                                                      ),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                              )
                                                              : Row(
                                                                children: [
                                                                  Text(
                                                                    '⭐ ${order.rating!.rating.toStringAsFixed(1)}',
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          Colors
                                                                              .amber,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  const Text(
                                                                    '(تم التقييم)',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          Colors
                                                                              .grey,
                                                                      fontFamily:
                                                                          'cairo',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  const Text(
                                                                    'مندوب التوصيل',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          Colors
                                                                              .grey,
                                                                      fontFamily:
                                                                          'cairo',
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    order
                                                                            .delivery
                                                                            ?.name ??
                                                                        'المندوب',
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'cairo',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .grey[200],
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                  child:
                                                                      (order.delivery?.images !=
                                                                                  null &&
                                                                              order.delivery!.images.isNotEmpty)
                                                                          ? Image.network(
                                                                            '$url/uploads/${order.delivery!.images[0]}',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder:
                                                                                (
                                                                                  context,
                                                                                  error,
                                                                                  stackTrace,
                                                                                ) => const Icon(
                                                                                  Icons.person,
                                                                                  color:
                                                                                      Colors.grey,
                                                                                ),
                                                                          )
                                                                          : const Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              fallback:
                                  (c) => Center(
                                    child: Text('لا يوجد بيانات ليتم عرضها'),
                                  ),
                            );
                          },
                          fallback: (c) => Center(child: CircularProgress()),
                        ),
                      )
                      : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
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
                                  borderRadius: BorderRadius.circular(30),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
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

void _showRatingDialog(BuildContext context, UserCubit cubit, Order order) {
  double selectedRating = 5.0;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'تقييم المندوب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'cairo',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child:
                          (order.delivery?.images != null &&
                                  order.delivery!.images.isNotEmpty)
                              ? Image.network(
                                '$url/uploads/${order.delivery!.images[0]}',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                              )
                              : const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.delivery?.name ?? 'اسم المندوب غير متوفر',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'كيف كانت تجربة التوصيل مع هذا المندوب؟',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int starValue = index + 1;
                      return IconButton(
                        icon: Icon(
                          starValue <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = starValue.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'cairo',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            cubit.submitDeliveryRating(
                              deliveryId: order.assignedDeliveryId,
                              orderId: order.id,
                              rating: selectedRating,
                              context: context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'إرسال التقييم',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'cairo',
                            ),
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
      );
    },
  );
}
