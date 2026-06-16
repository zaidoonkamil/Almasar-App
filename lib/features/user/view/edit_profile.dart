import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String? initialImageUrl;
  final String userId;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialPhone,
    this.initialImageUrl,
    required this.userId,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  XFile? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      if (_pickedImage != null) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              _pickedImage!.path,
              filename: _pickedImage!.name,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await DioHelper.postData(
        url: '/users/${widget.userId}/update',
        data: formData,
        token: token,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200) {
        showToastSuccess(
          text: 'تم تحديث الملف الشخصي بنجاح',
          context: context,
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (error is DioException) {
        final data = error.response?.data;
        String errorMsg = 'حدث خطأ أثناء التحديث';
        if (data is Map && data.containsKey('error')) {
          errorMsg = data['error'].toString();
        } else if (data is String) {
          errorMsg = data;
        }
        showToastError(
          text: errorMsg,
          context: context,
        );
      } else {
        showToastError(
          text: 'حدث خطأ غير متوقع',
          context: context,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image Selector
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _pickedImage != null
                                ? Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty
                                    ? Image.network(
                                        '$url/uploads/${widget.initialImageUrl}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          'assets/images/Group 1171275632 (1).png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/Group 1171275632 (1).png',
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Name Field
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'الاسم الكامل',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone Field
                  CustomTextField(
                    controller: _phoneController,
                    hintText: 'رقم الهاتف',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validate: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      if (value.trim().length != 11) {
                        return 'رقم الهاتف يجب أن يكون 11 رقماً';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),

                  // Save Button
                  GestureDetector(
                    onTap: _isLoading ? null : _saveProfile,
                    child: Container(
                      width: double.maxFinite,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
