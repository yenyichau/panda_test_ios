// Project imports:
import '../../imports.dart';

class AppText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final bool isOverflow;
  final double? height;
  final bool isRequired;
  final TextOverflow? textOverflow;

  const AppText(
    this.data, {
    this.color,
    this.fontSize,
    this.fontWeight,
    this.underline = false,
    this.maxLines,
    this.textAlign,
    this.fontStyle,
    this.isOverflow = false,
    this.height,
    this.isRequired = false,
    this.textOverflow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return !isRequired
        ? textWidget(context)
        : Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.fw),
                    child: const AppText(
                      "*",
                      color: Colors.red,
                    ),
                  ),
                ),
                WidgetSpan(
                  child: textWidget(context),
                ),
              ],
            ),
          );
  }

  Widget textWidget(BuildContext ctx) {
    TextStyle textModeTextStyle = TextStyle(
      color: Colors.black,
      fontSize: kFont15.sp,
      fontWeight: FontWeight.normal,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Text(
        data,
        maxLines: maxLines,
        overflow: !isOverflow ? null : textOverflow ?? TextOverflow.ellipsis,
        textAlign: textAlign,
        style: textModeTextStyle.copyWith(
          color:
              underline ? Colors.transparent : color ?? textModeTextStyle.color,
          fontSize: fontSize?.sp ?? textModeTextStyle.fontSize,
          fontWeight: fontWeight ?? textModeTextStyle.fontWeight,
          fontStyle: fontStyle ?? FontStyle.normal,
          height: height,
          decoration: underline ? TextDecoration.underline : null,
          shadows: underline
              ? [
                  const Shadow(
                    color: Colors.black,
                    offset: Offset(0, -4),
                  )
                ]
              : null,
        ),
      ),
    );
  }
}
