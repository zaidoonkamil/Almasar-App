import 'dart:async';

import 'package:delivery_app/features/delivery/cubit/states.dart';
import 'package:delivery_app/features/delivery/model/GetActiveOrders.dart';
import 'package:delivery_app/features/delivery/model/GetChangeOrders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/network/remote/socket_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/ProfileModel.dart';
import '../model/GetAllOrders.dart';
import '../model/GetDashboard.dart';
import '../model/GetTodayDashboard.dart';

class DeliveryCubit extends Cubit<DeliveryStates> {
  DeliveryCubit() : super(DeliveryInitialState());

  static DeliveryCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }



  deliveryStatus({
    required BuildContext context,
    required bool isActive,
  }){
    emit(DeliveryStatusLoadingState());
    DioHelper.putData(
      url: '/delivery/$id/status',
      token: token,
      data:
      {
        'isActive': isActive,
      },
    ).then((value) {
      profileModel = profileModel!.copyWith(isActive: !profileModel!.isActive);
      showToastSuccess(
        text:"تم تحديث الحالة بنجاح",
        context: context,
      );
      emit(DeliveryStatusSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeliveryStatusErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void getCurrentLocation({required BuildContext context}) async {
    emit(AddLocationLoadingState());
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToastInfo(
        text: 'خدمة تحديد الموقع غير مفعلة',
        context: context,);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToastInfo(
          text: 'تم رفض صلاحية الموقع',
          context: context,);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToastInfo(
        text: 'الصلاحية مرفوضة بشكل دائم',
        context: context,
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('الموقع الحالي: ${position.latitude}, ${position.longitude}');

    DioHelper.postData(
      url: '/delivery-locations',
      data:
      {
        'deliveryId': id,
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      },
    ).then((value) {
      showToastSuccess(
        text: "تم تحديد الموقع بنجاح",
        context: context,
      );
      emit(AddLocationSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print('Dio Error Status Code: ${error.response?.statusCode}');
        print('Dio Error Data: ${error.response?.data}');
        showToastError(
          text: error.response?.data["error"] ?? "حدث خطأ غير معروف",
          context: context,
        );
      }
    });
  }


  ProfileModel? profileModel;
  void getProfile({required BuildContext context,}) {
    emit(GetProfileLoadingState());
    DioHelper.getData(
        url: '/users/$id',
        token: token
    ).then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetProfileErrorStates());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetAds> getAdsModel = [];
  void getAds({BuildContext? context,}) {
    emit(GetAdsLoadingState());
    DioHelper.getData(
      url: '/ads',
    ).then((value) {
      getAdsModel = (value.data as List)
          .map((item) => GetAds.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetAdsErrorStates());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  GetDashboard? getDashboard;
  void getDashboardDelivery({BuildContext? context,}) {
    emit(GetDashboardDeliveryLoadingState());
    DioHelper.getData(
      url: '/delivery/$id/dashboard',
    ).then((value) {
      getDashboard = GetDashboard.fromJson(value.data);
      emit(GetDashboardDeliverySuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetDashboardDeliveryErrorStates());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  GetTodayDashboard? getTodayDashboard;
  void getTodayDashboardDelivery({BuildContext? context,}) {
    emit(GetTodayDashboardDeliveryLoadingState());
    DioHelper.getData(
      url: '/delivery/$id/today-dashboard',
    ).then((value) {
      getTodayDashboard = GetTodayDashboard.fromJson(value.data);
      emit(GetTodayDashboardDeliverySuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetTodayDashboardDeliveryErrorStates());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<Order> orders = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  GetAllOrders? orderModel;
  void getOrder({required String page, BuildContext? context,required String id}) {
    emit(GetOrderLoadingState());
    DioHelper.getData(
      url: '/delivery/$id/all-orders-delivery?$page',
    ).then((value) {
      orderModel = GetAllOrders.fromJson(value.data);
      orders.addAll(orderModel!.orders);
      pagination = orderModel!.pagination;
      currentPage = pagination!.currentPage;
      if (currentPage >= pagination!.totalPages) {
        isLastPage = true;
      }
      emit(GetOrderSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetOrderErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }



  void startAutoRefresh({required BuildContext context}) {
    getActiveOrder(context: context);
   Timer.periodic(Duration(minutes: 3), (timer) {
      getActiveOrder(context: context);
    });
  }

  List<GetActiveOrders>? getActiveOrdersModel;
  void getActiveOrder({required BuildContext context}) {
    emit(GetActiveOrderLoadingState());
    DioHelper.getData(
      url: '/delivery/$id/firststatus-orders-delivery',
    ).then((value) {
      List<GetActiveOrders> newData = (value.data as List)
          .map((item) => GetActiveOrders.fromJson(item))
          .toList();
      if (!listEquals(getActiveOrdersModel, newData)) {
        getActiveOrdersModel = newData;
        emit(GetActiveOrderSuccessState());
      }
      emit(GetActiveOrderSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetActiveOrderErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  deliveryAccept({required BuildContext context, required bool accept, required String idOrder,}){
    emit(DeliveryAcceptLoadingState());
    DioHelper.putData(
      url: '/order/$idOrder/delivery-accept',
      token: token,
      data:
      {
        'accept': accept,
        'deliveryId': id,
      },
    ).then((value) {
      if (accept==false) {
        getActiveOrdersModel?.removeWhere((order) => order.id.toString() == idOrder);
      }
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      emit(DeliveryAcceptSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeliveryAcceptErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  changeStatusOrder({required BuildContext context, required String status, required String idOrder,}){
    emit(ChangeStatusOrderLoadingState());
    DioHelper.putData(
      url: '/orders/$idOrder/status',
      token: token,
      data:
      {
        'status': status,
      },
    ).then((value) {
      getActiveOrdersModel?.removeWhere((order) => order.id.toString() == idOrder);
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      emit(ChangeStatusOrderSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print("Unknown Error: $error");

        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(ChangeStatusOrderErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

// void connectToSocket() {
  //   SocketHelper.connect();
  //
  //   SocketHelper.onEvent("connect", (_) {
  //     print('✅ Socket Connected');
  //     SocketHelper.emitEvent("test",
  //         {"message": "Hello from Flutter"});
  //
  //     listenToOrders();
  //   });
  //
  //   // الاستماع للأحداث
  //   SocketHelper.onEvent("test", (data) {
  //     print("📩 Received from server: $data");
  //   });
  // }
  //
  // List<GetChangeOrders> orderChangeModel = [];
  //
  // void listenToOrders() {
  //   print("Attempting to listen to deliveryOrders_$id");
  //   SocketHelper.onEvent("deliveryOrders_$id", (data) {
  //     print("📥 New Orders: $data");
  //     if (data != null && data.isNotEmpty) {
  //       // تحويل البيانات إلى قائمة موديلات
  //       List<GetChangeOrders> orders = List<GetChangeOrders>.from(
  //           data.map((orderJson) => GetChangeOrders.fromJson(orderJson))
  //       );
  //       orderChangeModel = orders;
  //       emit(SocketGetOrderSuccessState());
  //     } else {
  //       print("❌ No data received or data is empty.");
  //     }
  //   });
  // }



}