import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/auth/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/remote/dio_helper.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  void validation(){
    emit(ValidationState());
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


  signUp({required String name, required String phone, required String location, required String password, required String role, required BuildContext context,}) async {
    emit(SignUpLoadingState());

    if (role == 'vendor') {
      if (selectedImages.isEmpty) {
        showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
        emit(SignUpErrorState());
        return;
      }

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
        url: '/users',
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      ).then((value) {
        emit(SignUpSuccessState());
      }).catchError((error) {
        if (error is DioError) {
          print("Error Data: ${error.response?.data}");
          String errorMessage = handleDioError(error.response?.data);
          showToastError(
            text: errorMessage,
            context: context,
          );
          emit(SignUpErrorState());
        } else {
          print("Unknown Error: $error");
        }
      });

    } else {
      DioHelper.postData(
        url: '/users',
        data: {
          'name': name,
          'phone': phone,
          'location': location,
          'password': password,
          'role': role,
        },
      ).then((value) {
        emit(SignUpSuccessState());
      }).catchError((error) {
        if (error is DioError) {
          print("Error Data: ${error.response?.data}");
          String errorMessage = handleDioError(error.response?.data);
          showToastError(
            text: errorMessage,
            context: context,
          );
          emit(SignUpErrorState());
        } else {
          print("Unknown Error: $error");
        }
      });
    }
  }




  String? token;
  String? role;
  String? id;

  signIn({
    required String phone,
    required String password,
    required BuildContext context,
  }){
    emit(LoginLoadingState());
    DioHelper.postData(
      url: '/login',
      data:
      {
        'phone': phone,
        'password': password,
      },
    ).then((value) {
     token=value.data['token'];
     role=value.data['user']['role'];
     id=value.data['user']['id'].toString();
      emit(LoginSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"] ?? "حدث خطأ غير معروف",
          context: context,
        );
        emit(LoginErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


}