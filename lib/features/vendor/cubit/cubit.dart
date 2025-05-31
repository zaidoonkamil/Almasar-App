import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/vendor/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/GetOrder.dart';
import '../../user/model/ProfileModel.dart';
import '../model/GetProductsModel.dart';


class VendorCubit extends Cubit<VendorStates> {
  VendorCubit() : super(VendorInitialState());

  static VendorCubit get(context) => BlocProvider.of(context);

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

  List<Products> orderss = [];
  Paginations? paginations;
  int currentPages = 1;
  bool isLastPages = false;
  GetProductsModel? getProductsModel;
  void getProducts({required BuildContext context,}) {
    emit(GetProductsLoadingState());
    DioHelper.getData(
        url: '/vendor/$id/products',
        token: token
    ).then((value) {
      getProductsModel = GetProductsModel.fromJson(value.data);
      orderss.addAll(getProductsModel!.products);
      paginations = getProductsModel!.pagination;
      currentPages = paginations!.currentPage;
      if (currentPages >= paginations!.totalPages) {
        isLastPages = true;
      }
      emit(GetProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetProductsErrorStates());
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

  String handleDioError(dynamic data) {
    if (data == null) {
      return "حدث خطأ غير معروف";
    } else if (data is Map && data.containsKey("error")) {
      return data["error"].toString();
    } else if (data is String) {
      return data;
    } else if (data is List) {
      return data.join(", ");
    } else {
      return data.toString();
    }
  }

  addProducts({required String title, required String description, required String price,required BuildContext context,}) async {
    emit(AddProductsLoadingState());

      if (selectedImages.isEmpty) {
        showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
        emit(AddProductsErrorStates());
        return;
      }

      FormData formData = FormData.fromMap(
          {
            'title': title,
            'description': description,
            'price': price,
          },
          ListFormat.multiCompatible
      );

      for (var file in selectedImages) {
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

      DioHelper.postData(
        url: '/vendor/$id/products',
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      ).then((value) {
        emit(AddProductsSuccessState());
      }).catchError((error) {
        if (error is DioError) {
          showToastError(
            text: handleDioError(error.response?.data),
            context: context,
          );
          emit(AddProductsErrorStates());
        } else {
          print("Unknown Error: $error");
        }
      });
  }

  List<Order> orders = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  GetOrder? orderModel;
  void getOrder({required String page, BuildContext? context,}) {
    emit(GetOrderLoadingState());
    DioHelper.getData(
      url: '/vendor/$id/orders?page=$page',
    ).then((value) {
      orderModel = GetOrder.fromJson(value.data);
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

}