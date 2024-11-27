// Package imports:
import 'package:shimmer/shimmer.dart';

// Project imports:
import '../../imports.dart';

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.padding,
    this.margin,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    Color shimmerBaseColor = const Color.fromARGB(255, 110, 110, 110);
    Color shimmerHighlightColor = const Color.fromARGB(255, 233, 233, 233);

    return RepaintBoundary(
      child: kIsWeb
          ? Container(
              height: height,
              width: width,
              padding: padding,
              margin: margin,
              decoration: BoxDecoration(
                color: baseColor ?? shimmerBaseColor,
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radius ?? 0),
              ),
            )
          : Shimmer.fromColors(
              baseColor: baseColor ?? shimmerBaseColor,
              highlightColor: highlightColor ?? shimmerHighlightColor,
              child: Container(
                height: height,
                width: width,
                padding: padding,
                margin: margin,
                decoration: BoxDecoration(
                  color: baseColor ?? shimmerBaseColor,
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(radius ?? 0),
                ),
              ),
            ),
    );
  }
}
