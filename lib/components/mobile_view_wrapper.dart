import 'package:flutter/material.dart';
import '../configs/app_size.dart';

class MobileViewWrapper extends StatelessWidget {
  final Widget? child;
  const MobileViewWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = AppSize.width <= 600 ? AppSize.width : AppSize.mobileWebWidth;
    final height = AppSize.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        size: Size(width, height),
        textScaler: TextScaler.linear(
          AppSize.width > AppSize.mobileWebWidth
              ? 1.0
              : (1.0 * (AppSize.width / (AppSize.mobileWebWidth * 0.9))),
        ),
      ),
      child: Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}
