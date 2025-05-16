import 'package:delivery_app/features/admin/cubit/states.dart';
import 'package:delivery_app/features/delivery/model/GetChangeOrders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/network/remote/socket_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/ProfileModel.dart';
import '../model/GetDashboardAdmin.dart';
import '../model/GetTodayDashboardAdmin.dart';
import '../model/getNameUser.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
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

  // GetDashboard? getDashboard;
  // void getDashboardDelivery({BuildContext? context,}) {
  //   emit(GetDashboardDeliveryLoadingState());
  //   DioHelper.getData(
  //     url: '/delivery/$id/dashboard',
  //   ).then((value) {
  //     getDashboard = GetDashboard.fromJson(value.data);
  //     emit(GetDashboardDeliverySuccessState());
  //   }).catchError((error) {
  //     if (error is DioError) {
  //       showToastError(text: error.toString(),
  //         context: context!,);
  //       print(error.toString());
  //       emit(GetDashboardDeliveryErrorStates());
  //     }else {
  //       print("Unknown Error: $error");
  //     }
  //   });
  // }
  //
  // GetTodayDashboard? getTodayDashboard;
  // void getTodayDashboardDelivery({BuildContext? context,}) {
  //   emit(GetTodayDashboardDeliveryLoadingState());
  //   DioHelper.getData(
  //     url: '/delivery/$id/today-dashboard',
  //   ).then((value) {
  //     getTodayDashboard = GetTodayDashboard.fromJson(value.data);
  //     emit(GetTodayDashboardDeliverySuccessState());
  //   }).catchError((error) {
  //     if (error is DioError) {
  //       showToastError(text: error.toString(),
  //         context: context!,);
  //       print(error.toString());
  //       emit(GetTodayDashboardDeliveryErrorStates());
  //     }else {
  //       print("Unknown Error: $error");
  //     }
  //   });
  // }


  addPerson({
    required String name,
    required String phone,
    required String location,
    required String password,
    required String role,
    required BuildContext context,
  }){
    emit(AddPersonLoadingState());
    DioHelper.postData(
      url: '/users',
      data:
      {
        'name': name,
        'phone': phone,
        'location': location,
        'password': password,
        'role': role,
      },
    ).then((value) {
      emit(AddPersonSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"] ?? "حدث خطأ غير معروف",
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


  //
  // deliveryStatus({required BuildContext context, required bool isActive,}){
  //   emit(DeliveryStatusLoadingState());
  //   DioHelper.putData(
  //     url: '/delivery/$id/status',
  //     token: token,
  //     data:
  //     {
  //       'isActive': isActive,
  //     },
  //   ).then((value) {
  //     profileModel = profileModel!.copyWith(isActive: !profileModel!.isActive);
  //     showToastSuccess(
  //       text:"تم تحديث الحالة بنجاح",
  //       context: context,
  //     );
  //     emit(DeliveryStatusSuccessState());
  //   }).catchError((error)
  //   {
  //     if (error is DioError) {
  //       showToastError(
  //         text:"حدث خطأ",
  //         context: context,
  //       );
  //       emit(DeliveryStatusErrorState());
  //     }else {
  //       print("Unknown Error: $error");
  //     }
  //   });
  // }



}