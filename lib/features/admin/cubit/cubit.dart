import 'dart:async';

import 'package:delivery_app/features/admin/cubit/states.dart';
import 'package:delivery_app/features/admin/model/AllOrder.dart';
import 'package:delivery_app/features/delivery/model/GetActiveOrders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/ProfileModel.dart';
import '../model/GetActiveDeliveryModel.dart';
import '../model/GetDashboardAdmin.dart';
import '../model/GetTodayDashboardAdmin.dart';
import '../model/getNameUser.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }

  void verifyToken({required BuildContext context}) {
    emit(VerifyTokenLoadingState());
    DioHelper.getData(
        url: '/verify-token',
        token: token
    ).then((value) {
      bool isValid = value.data['valid'];
      if (isValid) {
        emit(VerifyTokenSuccessState());
      } else {
        signOut(context);
        showToastError(text: "توكن غير صالح", context: context);
        emit(VerifyTokenErrorState());
      }
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(VerifyTokenErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetNameUser>? getNameUserModel;
  void getNameUser({required BuildContext? context,required String role}) {
    emit(GetNameUserLoadingState());
    DioHelper.getData(
      url: '/users$role',
    ).then((value) {
      getNameUserModel = List<GetNameUser>.from(
          value.data.map((item) => GetNameUser.fromJson(item))
      );
      emit(GetNameUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetNameUserErrorState());
      }else {
        print("Unknown Error: $error");
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

  void deleteAds({required String id,required BuildContext context}) {
    emit(DeleteAdsLoadingState());
    DioHelper.deleteData(
      url: '/ads/$id',
    ).then((value) {
      getAdsModel.removeWhere((getAdsModel) => getAdsModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImages = resultList;
      emit(SelectedImagesState());
    }
  }

  List<XFile> selectedImages2 = [];
  Future<void> pickImages2() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImages2 = resultList;
      emit(SelectedImagesState());
    }
  }

  void addAds({required BuildContext context}) async {
    emit(AddAdsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      return;
    }
    FormData formData = FormData();
    for (var file in selectedImages) {
      formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              file.path, filename: file.name,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
    }
    DioHelper.postData(
      url: '/ads',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      selectedImages=[];
      emit(AddAdsSuccessState());
      showToastSuccess(text: "تم رفع الصور بنجاح!", context: context);
      getAds();
    }).catchError((error) {
      if (error is DioException) {
        showToastError(text: error.message!, context: context);
      } else {
        print("❌ Unknown Error: $error");
      }
      emit(AddAdsErrorState());
    });
  }

  addPerson({
    required String name,
    required String phone,
    required String location,
    required String password,
    required String role,
    required BuildContext context,
  })async{
    emit(AddPersonLoadingState());
    FormData formData = FormData.fromMap(
        {
          'name': name,
          'phone': phone,
          'location': location,
          'password': password,
          'role': role,
        },
        ListFormat.multiCompatible
    );
    if(role =='delivery'){
      if (selectedImages2.isEmpty) {
        showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
        emit(AddPersonErrorState());
        return;
      }
      for (var file in selectedImages2) {
        formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
    );
    }
    }

    DioHelper.postData(
      url: '/users',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddPersonSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddPersonErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  GetDashboardAdmin? getDashboard;
  void getDashboardAdmin({BuildContext? context,}) {
    emit(GetDashboardAdminLoadingState());
    DioHelper.getData(
      url: '/admin/dashboard',
    ).then((value) {
      getDashboard = GetDashboardAdmin.fromJson(value.data);
      emit(GetDashboardAdminSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetDashboardAdminErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  GetTodayDashboardAdmin? getTodayDashboard;
  void getTodayDashboardAdmin({BuildContext? context,}) {
    emit(GetTodayDashboardAdminLoadingState());
    DioHelper.getData(
      url: '/admin/today-dashboard',
    ).then((value) {
      getTodayDashboard = GetTodayDashboardAdmin.fromJson(value.data);
      emit(GetTodayDashboardAdminSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetTodayDashboardAdminErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  String? lat;
  String? long;
  void getLatAndLong({required BuildContext context,required String id}) {
    emit(GetLatAndLongLoadingState());
    DioHelper.getData(
      url: '/delivery-locations/$id',
    ).then((value) {
      lat =  value.data[0]['latitude'];
      long =  value.data[0]['longitude'];
      emit(GetLatAndLongSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: 'خطأ في جلب الموقع',
          context: context!,);
        print(error.toString());
        emit(GetLatAndLongErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void openMap({required BuildContext context,}) async {
    if (lat != null && long != null) {
      String googleMapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      await launchUrl(
        Uri.parse(googleMapUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      showToastError(
        text: 'لا يمكن فتح الخريطة',
        context: context,
      );
    }
  }

  List<Order> orders = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  AllOrder? allOrderModel;
  void allOrder({required String page,required BuildContext context,}) {
    emit(GetAllOrderLoadingState());
    DioHelper.getData(
      url: '/admin/all-orders?$page',
    ).then((value) {
      allOrderModel = AllOrder.fromJson(value.data);
      orders.addAll(allOrderModel!.orders);
      pagination = allOrderModel!.pagination;
      currentPage = pagination!.currentPage;
      if (currentPage >= pagination!.totalPages) {
        isLastPage = true;
      }
      emit(GetAllOrderSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetAllOrderErrorState());
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
      url: '/admin/order-pending',
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


  void startAutoRefreshActiveDelivery({required BuildContext context}) {
    getActiveDelivery(context: context);
    Timer.periodic(Duration(minutes: 1), (timer) {
      getActiveDelivery(context: context);
    });
  }

  List<GetActiveDeliveryModel>? getActiveDeliveryModel;
  void getActiveDelivery({required BuildContext context}) {
    emit(GetActiveDeliveryLoadingState());
    DioHelper.getData(
      url: '/admin/delivery-active',
    ).then((value) {
      List<GetActiveDeliveryModel> newData = (value.data as List)
          .map((item) => GetActiveDeliveryModel.fromJson(item))
          .toList();
      if (!listEquals(getActiveDeliveryModel, newData)) {
        getActiveDeliveryModel = newData;
        emit(GetActiveDeliverySuccessState());
      }
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetActiveDeliveryErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  deliveriesAssignOrder({required BuildContext context, required String idOrder,required String deliveryId,}){
    emit(DeliveriesAssignOrderLoadingState());
    DioHelper.putData(
      url: '/order/$idOrder/assign',
      token: token,
      data:
      {
        'deliveryId': deliveryId,
      },
    ).then((value) {
      getActiveOrdersModel?.firstWhere(
            (order) => order.id.toString() == idOrder,
      ).assignedDeliveryId = 0;

      showToastSuccess(
        text:"تم توجيه الطلب بنجاح",
        context: context,
      );
      emit(DeliveriesAssignOrderSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print("Unknown Error: $error");

        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeliveriesAssignOrderErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteUser({required BuildContext context,required String id}) {
    emit(DeleteUserLoadingState());
    DioHelper.deleteData(
        url: '/users/$id',
    ).then((value) {
        showToastSuccess(text: "تمت عملية الحذف بنجاح", context: context);
        emit(DeleteUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(DeleteUserErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  TextEditingController userNameController = TextEditingController();
  void getFirstCall({required String sponsorshipAmount}){
    userNameController.text=sponsorshipAmount;
  }

  void sponsorshipVendor({required BuildContext context,required String id,required String sponsorshipAmount}) {
    emit(SponsorshipVendorLoadingState());
    DioHelper.putData(
        url: '/vendor/$id/sponsorship',
      data: {
          'sponsorshipAmount': sponsorshipAmount,
      }
    ).then((value) {
        showToastSuccess(text: "تمت عملية الترقية بنجاح", context: context);
        emit(SponsorshipVendorSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(SponsorshipVendorErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


}