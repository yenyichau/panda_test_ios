// Project imports:
import '../../imports.dart';

class AppButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final double? radius;
  final double? textSize;
  final FontWeight? fontWeight;
  final Widget? builder;
  final Color? buttonColor;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final List<double>? stops;
  final double? borderStroke;
  final bool textIgnoreLine;
  final Widget? icon;
  final bool checkLogin;
  final double? iconSpace;
  final bool isMinWidth;
  final Color? borderColor;

  const AppButton({
    this.onTap,
    this.buttonColor,
    this.begin,
    this.end,
    this.stops,
    this.borderStroke,
    this.text,
    this.builder,
    this.padding,
    this.textColor,
    this.radius,
    this.textSize,
    this.fontWeight,
    this.textIgnoreLine = false,
    this.icon,
    this.checkLogin = false,
    this.iconSpace,
    this.isMinWidth = false,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellWrapper(
      onTap: onTap != null
          ? () {
              onTap!();
            }
          : null,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 6).r,
        margin: EdgeInsets.all(borderStroke ?? 0),
        decoration: onTap != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 8).r,
                color: buttonColor ?? Colors.white,
                border: Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderStroke ?? 0.0,
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 8).r,
                color: Colors.grey,
                border: Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderStroke ?? 0.0,
                ),
              ),
        child: builder ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: isMinWidth ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: iconSpace ?? 10).r,
                    child: icon!,
                  ),
                AppText(
                  text ?? "",
                  fontSize: textSize ?? kFont14,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color:
                      onTap != null ? textColor ?? Colors.black : Colors.white,
                  isOverflow: textIgnoreLine,
                ),
              ],
            ),
      ),
    );
  }
}
