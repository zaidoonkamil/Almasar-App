import 'package:flutter/material.dart';

void navigateTo(context, nextPage) => Navigator.push(
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