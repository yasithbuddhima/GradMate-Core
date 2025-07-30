import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loadingScreen() {
  return Center(
    child: SizedBox(
      width: 200,
      child: Lottie.asset('assets/animations/ghost.json'),
    ),
  );
}
