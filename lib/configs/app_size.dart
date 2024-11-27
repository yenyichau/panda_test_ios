// Project imports:
import '../imports.dart';

class AppSize {
  // for mobile web
  static double mobileWebWidth = 470.w;
  static double getSize(num size) {
    return width * (size / mobileWebWidth);
  }

  // get app width
  static double get width => kIsWeb
      ? (1.sw < mobileWebWidth
          ? (mobileWebWidth - (mobileWebWidth - 1.sw))
          : mobileWebWidth)
      : 1.sw;

  // get app height
  static double get height => 1.sh;
}
