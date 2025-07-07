import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

EdgeInsetsGeometry kdefaultPadding = const EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 10,
);

// Device width and height
double kscreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double kscreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Device type (laptop , tablet , mobile)
bool kisMobile(BuildContext context) {
  return kscreenWidth(context) < 600;
}
