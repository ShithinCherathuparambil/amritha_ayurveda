import 'package:amritha_ayurveda/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..maskColor = Colors.white
    ..indicatorColor = Coloring.primaryColor
    ..userInteractions = false
    ..dismissOnTap = false
    ..textColor = Colors.transparent
    ..contentPadding = const EdgeInsets.all(8)
    ..textPadding = EdgeInsets.zero
    ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..indicatorSize = 23
    ..lineWidth = 2.2
    ..radius = 20
    ..boxShadow = <BoxShadow>[
      const BoxShadow(
        offset: Offset(2, 2),
        blurRadius: 10,
        color: Color.fromRGBO(0, 0, 0, .15),
      ),
    ];
}
