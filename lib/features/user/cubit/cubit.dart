import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/user/cubit/states.dart';
import 'package:geolocator/geolocator.dart';
import 'package:delivery_app/features/user/model/GetCartModel.dart';
import 'package:delivery_app/features/user/model/ProductsVendorModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../model/GetAdsModel.dart';
import '../model/GetOrder.dart';
import '../model/ProfileModel.dart';
import '../model/VendorModel.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  List<Datum> allVendors = [];
  bool isVendorLoadingMore = false;
  double? latitude;
  double? longitude;

  static UserCubit get(context) => BlocProvider.of(context);

  void slid() {
    emit(ValidationState());
  }

  void verifyToken({required BuildContext context}) {
    if (token == '') {
      return emit(VerifyTokenErrorState());
    }
    emit(VerifyTokenLoadingState());
    DioHelper.getData(url: '/verify-token', token: token)
        .then((value) {
          bool isValid = value.data['valid'];
          if (isValid) {
            emit(VerifyTokenSuccessState());
          } else {
            signOut(context);
            showToastError(text: "توكن غير صالح", context: context);
            emit(VerifyTokenErrorState());
          }
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            emit(VerifyTokenErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  List<GetAds> getAdsModel = [];
  void getAds({BuildContext? context}) {
    emit(GetAdsLoadingState());
    DioHelper.getData(url: '/ads')
        .then((value) {
          getAdsModel =
              (value.data as List)
                  .map((item) => GetAds.fromJson(item as Map<String, dynamic>))
                  .toList();
          emit(GetAdsSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(text: error.toString(), context: context!);
            print(error.toString());
            emit(GetAdsErrorStates());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  ProfileModel? profileModel;
  void getProfile({required BuildContext context}) {
    if (token == '' || id == '') {
      profileModel = ProfileModel(
        id: 1,
        name: "ضيف",
        phone: "",
        isActive: false,
        location: "الرياض - حي النخيل",
        createdAt: DateTime.now(),
        images: [],
      );
      return emit(GetProfileSuccessState());
    }
    emit(GetProfileLoadingState());
    DioHelper.getData(url: '/users/$id', token: token)
        .then((value) {
          profileModel = ProfileModel.fromJson(value.data);
          emit(GetProfileSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            print(error.toString());
            emit(GetProfileErrorStates());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  addOrder({
    required String address,
    required String phone,
    required String orderAmount,
    required String deliveryFee,
    required String notes,
    required BuildContext context,
    double? latitude,
    double? longitude,
  }) {
    emit(AddOrderLoadingState());
    DioHelper.postData(
          url: '/orders',
          data: {
            'userId': id,
            'address': address,
            'phone': phone,
            'orderAmount': orderAmount,
            'deliveryFee': deliveryFee,
            'notes': notes,
            if (latitude != null) 'latitude': latitude,
            if (longitude != null) 'longitude': longitude,
          },
        )
        .then((value) {
          emit(AddOrderSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(
              text: error.response?.data["error"] ?? "حدث خطأ غير معروف",
              context: context,
            );
            emit(AddOrderErrorState());
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
  void getOrder({required String page, BuildContext? context}) {
    if (page == '1') {
      orders = [];
      isLastPage = false;
      currentPage = 1;
    }
    emit(GetOrderLoadingState());
    DioHelper.getData(url: '/orders/$id?page=$page')
        .then((value) {
          orderModel = GetOrder.fromJson(value.data);
          orders.addAll(orderModel!.orders);
          pagination = orderModel!.pagination;
          currentPage = pagination!.currentPage;
          if (currentPage >= pagination!.totalPages) {
            isLastPage = true;
          }
          emit(GetOrderSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            // showToastError(text: error.toString(),
            //   context: context!,);
            // print(error.toString());
            emit(GetOrderErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  void submitDeliveryRating({
    required int deliveryId,
    required int orderId,
    required double rating,
    required BuildContext context,
  }) {
    emit(SubmitRatingLoadingState());
    DioHelper.postData(
          url: '/delivery-rating',
          data: {
            'deliveryId': deliveryId,
            'userId': id,
            'orderId': orderId,
            'rating': rating,
            'comment': '',
          },
        )
        .then((value) {
          showToastSuccess(text: "تم إرسال التقييم بنجاح", context: context);
          emit(SubmitRatingSuccessState());
          orders = [];
          getOrder(page: '1', context: context);
        })
        .catchError((error) {
          if (error is DioException) {
            String errorMsg = "حدث خطأ أثناء إرسال التقييم";
            if (error.response?.data is Map &&
                error.response?.data["error"] != null) {
              errorMsg = error.response?.data["error"];
            }
            showToastError(text: errorMsg, context: context);
            emit(SubmitRatingErrorState());
          } else {
            print("Unknown Error: $error");
            emit(SubmitRatingErrorState());
          }
        });
  }

  PaginationVendor? paginationVendor;
  VendorModel? vendorModel;
  String vendorSearchQuery = '';
  bool isVendorSearchLoadingMore = false;
  String selectedCategory = 'الكل';

  void changeCategory(
    String category,
    BuildContext context, {
    String query = '',
  }) {
    selectedCategory = category;
    emit(ValidationState());
    if (query.isNotEmpty) {
      searchVendor(page: '1', query: query, context: context);
    } else {
      getVendor(page: '1', context: context);
    }
  }

  void getVendor({required String page, required BuildContext context}) {
    if (page == '1') {
      allVendors = [];
      emit(GetVendorLoadingState());
    } else {
      isVendorLoadingMore = true;
      emit(GetVendorSuccessState());
    }

    DioHelper.getData(
          url: '/vendorbysponsored?page=$page&category=$selectedCategory',
        )
        .then((value) {
          vendorModel = VendorModel.fromJson(value.data);
          if (page == '1') {
            allVendors = vendorModel!.data;
          } else {
            allVendors.addAll(vendorModel!.data);
            isVendorLoadingMore = false;
          }
          emit(GetVendorSuccessState());
        })
        .catchError((error) {
          isVendorLoadingMore = false;
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            print(error.toString());
            emit(GetVendorErrorState());
          } else {
            print("Unknown Error: $error");
            emit(GetVendorErrorState());
          }
        });
  }

  void searchVendor({
    required String page,
    required String query,
    required BuildContext context,
    String limit = '10',
  }) {
    print('🔎 searchVendor called: page=$page query="$query" limit=$limit');
    if (page == '1') {
      allVendors = [];
      vendorSearchQuery = query;
      emit(SearchVendorLoadingState());
    } else {
      isVendorSearchLoadingMore = true;
      emit(SearchVendorSuccessState());
    }

    DioHelper.getData(
          url:
              '/vendor-search?search=$query&page=$page&limit=$limit&category=$selectedCategory',
        )
        .then((value) {
          print('🔎 searchVendor response keys: ${value.data.keys}');
          vendorModel = VendorModel.fromJson(value.data);
          print(
            '🔎 parsed vendorModel, data length: ${vendorModel!.data.length}',
          );
          if (page == '1') {
            allVendors = vendorModel!.data;
          } else {
            allVendors.addAll(vendorModel!.data);
            isVendorSearchLoadingMore = false;
          }
          emit(SearchVendorSuccessState());
        })
        .catchError((error) {
          isVendorSearchLoadingMore = false;
          print('🔎 searchVendor error: $error');
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            print(error.toString());
            emit(SearchVendorErrorState());
          } else {
            print("Unknown Error: $error");
            emit(SearchVendorErrorState());
          }
        });
  }

  ProductsVendorModel? productsVendorModel;
  void getProductsVendor({
    required String page,
    required String id,
    required BuildContext context,
  }) {
    emit(GetProductsVendorLoadingState());
    DioHelper.getData(url: '/vendor/$id/products?page=$page')
        .then((value) {
          productsVendorModel = null;
          productsVendorModel = ProductsVendorModel.fromJson(value.data);
          emit(GetProductsVendorSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            print(error.toString());
            emit(GetProductsVendorErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  void getProductsVendorSearch({
    required String title,
    required String page,
    required String id,
    required BuildContext context,
  }) {
    emit(GetProductsVendorLoadingState());
    DioHelper.getData(
          url: '/vendor/$id/products/search?title=$title&page=$page',
        )
        .then((value) {
          productsVendorModel = null;
          productsVendorModel = ProductsVendorModel.fromJson(value.data);
          emit(GetProductsVendorSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(text: error.toString(), context: context);
            emit(GetProductsVendorErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  int quantity = 1;
  void add() {
    quantity++;
    emit(AddState());
  }

  void minus({required BuildContext c}) {
    quantity--;
    if (quantity <= 0) {
      showToastInfo(context: c, text: 'اقل عدد للطلب');
      quantity = 1;
      return;
    }
    emit(AddState());
  }

  addProductsToCart({
    required String productId,
    required BuildContext context,
  }) {
    emit(AddOrderLoadingState());
    DioHelper.postData(
          url: '/cart',
          data: {'userId': id, 'productId': productId, 'quantity': quantity},
        )
        .then((value) {
          showToastSuccess(text: value.data["message"], context: context);
          emit(AddOrderSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            print(error.response?.data["error"]);
            showToastError(
              text: error.response?.data["error"],
              context: context,
            );
            emit(AddOrderErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  List<GetCartModel> getCartModel = [];
  void getCart({required BuildContext context}) {
    emit(GetCartLoadingState());
    DioHelper.getData(url: '/cart/$id', token: token)
        .then((value) {
          getCartModel =
              (value.data as List)
                  .map(
                    (item) =>
                        GetCartModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
          emit(GetCartSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            String errorMessage = "حدث خطأ أثناء جلب السلة";
            if (error.response?.data != null) {
              final data = error.response!.data;
              if (data is Map && data.containsKey("error")) {
                errorMessage = data["error"]?.toString() ?? errorMessage;
              } else if (data is String) {
                errorMessage = data;
              }
            }
            showToastError(text: errorMessage, context: context);
            emit(GetCartErrorStates());
          } else {
            print("Unknown Error: $error");
            emit(GetCartErrorStates());
          }
        });
  }

  void deleteProductsInCart({
    required BuildContext context,
    required String id,
  }) {
    emit(DeleteCartLoadingState());
    DioHelper.deleteData(url: '/cart/$id', token: token)
        .then((value) {
          getCart(context: context);
          showToastSuccess(text: 'تمت عملية الحذف بنجاح', context: context);
          emit(DeleteCartSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(
              text: error.response?.data["error"],
              context: context,
            );
            emit(DeleteCartErrorStates());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  void deleteProductsInOfVendor({
    required BuildContext context,
    required String vendorId,
    required String productId,
  }) {
    emit(DeleteCartLoadingState());
    DioHelper.deleteData(
          url: '/vendor/$vendorId/products/$productId',
          token: token,
        )
        .then((value) {
          getProductsVendor(page: '1', context: context, id: vendorId);
          showToastSuccess(text: 'تمت عملية الحذف بنجاح', context: context);
          emit(DeleteCartSuccessState());
        })
        .catchError((error) {
          if (error is DioException) {
            showToastError(
              text: error.response?.data["error"],
              context: context,
            );
            emit(DeleteCartErrorStates());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  addOrderCart({
    required String idVendor,
    required String address,
    required String phone,
    required String notes,
    required List<Map<String, dynamic>> products,
    required BuildContext context,
    double? latitude,
    double? longitude,
  }) {
    emit(AddOrderCartLoadingState());
    DioHelper.postData(
          url: '/vendor/$idVendor/orders',
          data: {
            'address': address,
            'phone': phone,
            'notes': notes,
            'userId': id,
            'products': products,
            if (latitude != null) 'latitude': latitude,
            if (longitude != null) 'longitude': longitude,
          },
        )
        .then((value) {
          emit(AddOrderCartSuccessState());
        })
        .catchError((error) {
          print(products);
          if (error is DioException) {
            print(error.response?.data["error"]);
            showToastError(
              text: error.response?.data["error"],
              context: context,
            );
            emit(AddOrderCartErrorState());
          } else {
            print("Unknown Error: $error");
          }
        });
  }

  void getCurrentLocation({required BuildContext context}) async {
    emit(GetUserLocationLoadingState());
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToastInfo(text: 'خدمة تحديد الموقع غير مفعلة', context: context);
      emit(GetUserLocationErrorState());
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToastInfo(text: 'تم رفض صلاحية الموقع', context: context);
        emit(GetUserLocationErrorState());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToastInfo(text: 'الصلاحية مرفوضة بشكل دائم', context: context);
      emit(GetUserLocationErrorState());
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      emit(GetUserLocationSuccessState());
    } catch (e) {
      print("Error getting location: $e");
      emit(GetUserLocationErrorState());
    }
  }
}
