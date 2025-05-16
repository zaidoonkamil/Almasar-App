import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../styles/themes.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/Animation - 1746994148946.json');
  }
}