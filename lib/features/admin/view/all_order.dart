import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/view/chat_screen.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AllOrdersAdmin extends StatefulWidget {
  const AllOrdersAdmin({super.key, required this.urll, required this.appBarText});

  final String urll;
  final String appBarText;

  @override
  State<AllOrdersAdmin> createState() => _AllOrdersAdminState();
}

class _AllOrdersAdminState extends State<AllOrdersAdmin> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, AdminCubit cubit) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      cubit.searchOrders(query, url: widget.urll, context: context);
    });
  }

  Widget _buildFilterChips(AdminCubit cubit) {
    final List<String> statuses = [
      'الكل',
      'تم الاستلام',
      'تم التسليم',
      'استرجاع الطلب',
      'تبديل الطلب',
    ];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: statuses.length,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = cubit.selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ChoiceChip(
              label: Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: Colors.white,
              onSelected: (selected) {
                if (selected) {
                  cubit.filterByStatus(status, url: widget.urll, context: context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortButton(AdminCubit cubit) {
    final Map<String, String> sortOptions = {
      'date_desc': 'التاريخ: الأحدث أولاً',
      'date_asc': 'التاريخ: الأقدم أولاً',
      'amount_desc': 'المبلغ: الأعلى أولاً',
      'amount_asc': 'المبلغ: الأقل أولاً',
    };

    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort_rounded, size: 28, color: Colors.black87),
      onSelected: (value) {
        cubit.sortOrders(value, url: widget.urll, context: context);
      },
      itemBuilder: (context) {
        return sortOptions.entries.map((entry) {
          final isSelected = cubit.selectedSort == entry.key;
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isSelected)
                  const Icon(Icons.check, color: primaryColor, size: 18)
                else
                  const SizedBox(width: 18),
                Text(
                  entry.value,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? primaryColor : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..allOrder(page: '1',context: context, url: widget.urll,),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
              body: Column(
                children: [
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: (){
                              navigateBack(context);
                            },
                            child: const Icon(Icons.arrow_back_ios_new,size: 28,)),
                        Text(
                          widget.appBarText,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search & Sort Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        _buildSortButton(cubit),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: 'بحث برقم الطلب، العميل، التاجر...',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                prefixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          cubit.searchOrders('', url: widget.urll, context: context);
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.clear_rounded, color: Colors.grey),
                                      )
                                    : const Icon(Icons.search_rounded, color: Colors.grey),
                              ),
                              onChanged: (val) {
                                _onSearchChanged(val, cubit);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Filter Chips
                  _buildFilterChips(cubit),
                  const SizedBox(height: 10),
                  ConditionalBuilder(
                    condition: cubit.allOrderModel != null,
                    builder: (c){
                      return ConditionalBuilder(
                          condition: cubit.allOrderModel!.pagination.totalPages != 0,
                          builder: (c){
                            return Expanded(
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: cubit.orders.length,
                                  itemBuilder: (context,index){
                                    DateTime dateTime = DateTime.parse(cubit.orders[index].createdAt.toString());
                                    String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                    String formattedTime = DateFormat('h:mm a').format(dateTime);
                                    if (index == cubit.orders.length - 1 && !cubit.isLastPage) {
                                      cubit.allOrder(page: (cubit.currentPage + 1).toString(),context:context, url: widget.urll);
                                    }
                                    return  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${cubit.orders[index].id}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      " طلب #",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              width: double.maxFinite,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              decoration: BoxDecoration(
                                                color:cubit.orders[index].status == 'تم الاستلام'?
                                                Colors.blue.withOpacity(0.1):cubit.orders[index].status == 'تم التسليم'?
                                                Colors.green.withOpacity(0.1):cubit.orders[index].status == 'استرجاع الطلب'?
                                                Colors.red.withOpacity(0.1):Colors.orange.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                cubit.orders[index].status,
                                                style: TextStyle(
                                                  color: cubit.orders[index].status == 'تم الاستلام'?
                                                  Colors.blue:cubit.orders[index].status == 'تم التسليم'?
                                                  Colors.green:cubit.orders[index].status == 'استرجاع الطلب'?
                                                  Colors.red:Colors.orange,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  cubit.orders[index].vendor?.name ?? "متجر غير معروف",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(
                                                  Icons.store_mall_directory_outlined,
                                                  color: primaryColor,
                                                  size: 24,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final url = 'tel:${cubit.orders[index].phone}';
                                                    try {
                                                      await launch(
                                                        url,
                                                        enableJavaScript: true,
                                                      );
                                                    } catch (e) {
                                                      showToastError(
                                                        text: e.toString(),
                                                        context: context,
                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text( cubit.orders[index].phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.phone_outlined, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedTime ,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    if (cubit.orders[index].latitude != null &&
                                                        cubit.orders[index].longitude != null)
                                                      GestureDetector(
                                                        onTap: () async {
                                                          final lat = cubit.orders[index].latitude;
                                                          final lng = cubit.orders[index].longitude;
                                                          final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                                          try {
                                                            await launch(url, enableJavaScript: true);
                                                          } catch (e) {
                                                            showToastError(text: e.toString(), context: context);
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(6),
                                                            border: Border.all(color: Colors.blue),
                                                          ),
                                                          child: const Row(
                                                            children: [
                                                              Icon(Icons.map, color: Colors.blue, size: 14),
                                                              SizedBox(width: 4),
                                                              Text(
                                                                'خرائط جوجل',
                                                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      const SizedBox(),
                                                    const SizedBox(width: 8),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(cubit.orders[index].address,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14), overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),
                                                        const SizedBox(width: 6),
                                                        const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                cubit.orders[index].items != null && cubit.orders[index].items!.isNotEmpty
                                                    ?Container():Row(
                                                  children: [
                                                    Text(
                                                      'د.ع ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.orders[index].deliveryFee.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Icon(Icons.delivery_dining, color: Colors.grey),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ' د.ع ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.orders[index].orderAmount.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Icon(Icons.price_change_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  ': ملاحظات',
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    // color: Color(0xFFFE6B35),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                cubit.orders[index].notes == ''? Expanded(
                                                  child: Text(
                                                    'لا يوجد',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ):Expanded(
                                                  child: Text(
                                                    cubit.orders[index].notes,
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Color(0xFFFE6B35),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Column(
                                              children: [
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': المستخدم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.person_outline, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].user.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.phone_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(child: Text( cubit.orders[index].user.location,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                            cubit.orders[index].rejectionReason != '' ?Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ': سبب رفض الدلفري',
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        // color: Color(0xFFFE6B35),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        cubit.orders[index].rejectionReason,
                                                        textAlign: TextAlign.end,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          // color: Color(0xFFFE6B35),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].delivery != null ?Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': الدليفري',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].delivery!.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.person_outline, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final url = 'tel:${cubit.orders[index].delivery!.phone}';
                                                    try {
                                                      await launch(
                                                        url,
                                                        enableJavaScript: true,
                                                      );
                                                    } catch (e) {
                                                      showToastError(
                                                        text: e.toString(),
                                                        context: context,
                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text( cubit.orders[index].delivery!.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.phone_outlined, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( cubit.orders[index].delivery!.location,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( DateFormat('yyyy/M/d').format(DateTime.parse(cubit.orders[index].statusHistory.last.changeDate.toString())).toString()
                                                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.date_range, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text( DateFormat('h:mm a').format(DateTime.parse(cubit.orders[index].statusHistory.last.changeDate.toString())).toString()
                                                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.data_exploration, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].statusHistory.last.status != "تم الاستلام"
                                                && cubit.orders[index].statusHistory.last.status != "تم التسليم"
                                                && (cubit.orders[index].statusHistory.last.note?.isNotEmpty ?? false)
                                                ?Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Container(width: double.maxFinite,height: 1,color: Colors.black45,),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(': سبب الحالة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(child: Text(
                                                      cubit.orders[index].statusHistory.last.note!,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.note_alt_outlined, color: Colors.grey),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ):Container(),
                                            cubit.orders[index].items != null && cubit.orders[index].items!.isNotEmpty ?Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                Container(width: double.maxFinite,height: 2,color: Colors.grey,),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      physics: AlwaysScrollableScrollPhysics(),
                                                      itemCount: cubit.orders[index].items?.length,
                                                      itemBuilder:(context,itemIndex){
                                                        int number = int.parse(cubit.orders[index].items![itemIndex].product.price.toString());
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(width: 12,),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(cubit.orders[index].items![itemIndex].product.title.toString(),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 4,),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text('د.ع',style: TextStyle(color: primaryColor),),
                                                                          SizedBox(width: 4,),
                                                                          Text(NumberFormat('#,###').format(number).toString()),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(width: 12,),
                                                                Container(
                                                                  width: 64,
                                                                  height: 64,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius.circular(6.0),
                                                                    child: Image.network(
                                                                      '$url/uploads/${cubit.orders[index].items![itemIndex].product.images[0].toString()}',
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text('${itemIndex+1}',style: TextStyle(color: primaryColor,fontSize: 14),),
                                                                    SizedBox(width: 2,),
                                                                    Text('#',style: TextStyle(fontSize: 14),),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ):const SizedBox(height: 12),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton.icon(
                                                    onPressed: () {
                                                      navigateTo(
                                                        context,
                                                        ChatScreen(
                                                          orderId: cubit.orders[index].id,
                                                          otherUserId: cubit.orders[index].userId,
                                                          otherUserName: cubit.orders[index].user.name,
                                                          otherUserRole: 'user',
                                                          orderStatus: cubit.orders[index].status,
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(Icons.chat_outlined, size: 14, color: primaryColor),
                                                    label: const Text(
                                                      'دردشة الزبون',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: 'cairo',
                                                        fontWeight: FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(color: primaryColor),
                                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (cubit.orders[index].vendorId != null && cubit.orders[index].vendor != null) ...[
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: OutlinedButton.icon(
                                                      onPressed: () {
                                                        navigateTo(
                                                          context,
                                                          ChatScreen(
                                                            orderId: cubit.orders[index].id,
                                                            otherUserId: cubit.orders[index].vendorId!,
                                                            otherUserName: cubit.orders[index].vendor!.name,
                                                            otherUserRole: 'vendor',
                                                            orderStatus: cubit.orders[index].status,
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(Icons.store_mall_directory_outlined, size: 14, color: Colors.green),
                                                      label: const Text(
                                                        'دردشة المتجر',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: 'cairo',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(color: Colors.green),
                                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                if (cubit.orders[index].assignedDeliveryId != null && cubit.orders[index].delivery != null) ...[
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: OutlinedButton.icon(
                                                      onPressed: () {
                                                        navigateTo(
                                                          context,
                                                          ChatScreen(
                                                            orderId: cubit.orders[index].id,
                                                            otherUserId: cubit.orders[index].assignedDeliveryId!,
                                                            otherUserName: cubit.orders[index].delivery!.name,
                                                            otherUserRole: 'delivery',
                                                            orderStatus: cubit.orders[index].status,
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(Icons.delivery_dining_outlined, size: 14, color: Colors.blueAccent),
                                                      label: const Text(
                                                        'دردشة المندوب',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: 'cairo',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blueAccent,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(color: Colors.blueAccent),
                                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          },
                          fallback: (c)=>Expanded(child: Center(child: Text('لا يوجد بيانات ليتم عرضها',style: TextStyle(fontSize: 16),))));
                    },
                    fallback: (c)=>Expanded(child: Center(child: CircularProgress())),
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
