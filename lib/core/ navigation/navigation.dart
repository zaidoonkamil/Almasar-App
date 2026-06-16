import 'package:flutter/material.dart';

Future<T?> navigateTo<T>(BuildContext context, Widget nextPage) => Navigator.push<T>(
  context,
  MaterialPageRoute(
    builder: (context) => nextPage,
  ),
);

void navigateBack(context) => Navigator.pop(context);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (route) {
    return false;
  },
);