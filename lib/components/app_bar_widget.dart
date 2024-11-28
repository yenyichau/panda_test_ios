// Project imports:
import '../../imports.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool? centerTitle;
  final Widget? title, leading;
  final List<Widget>? actions;
  final String? text;
  final bool lightMode;
  final Color? backgroundColor;
  final Widget? bottomWidget;
  final double? textSize;
  final Color? textColor;

  AppBarWidget({
    super.key,
    this.centerTitle = false,
    this.title,
    this.leading,
    this.actions,
    this.text,
    this.lightMode = true,
    this.backgroundColor,
    this.bottomWidget,
    this.textSize,
    this.textColor,
  }) : preferredSize = Size.fromHeight(kToolbarHeight.fh + 0.5.fh);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  final Size preferredSize;
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final GlobalKey<PopupMenuButtonState<String>> popupMenuKey =
      GlobalKey<PopupMenuButtonState<String>>();

  @override
  Widget build(BuildContext context) {
    return appBar();
  }

  Widget appBar() {
    double leadingWidth = kToolbarHeight.fw;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.fh + 0.5.fh),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight.fh,
              child: AppBar(
                toolbarHeight: kToolbarHeight.fh,
                leadingWidth: widget.leading != null ? leadingWidth : 0,
                systemOverlayStyle: widget.lightMode
                    ? SystemUiOverlayStyle.dark
                    : SystemUiOverlayStyle.light,
                centerTitle: widget.centerTitle,
                backgroundColor: widget.backgroundColor ?? Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: widget.text != null
                    ? AppText(
                        widget.text!,
                        color: widget.textColor ?? Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: widget.textSize ?? kFont12,
                      )
                    : widget.title,
                leading: widget.leading ?? const SizedBox.shrink(),
                actions: widget.actions,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                actionsIconTheme: const IconThemeData(
                  color: Colors.black,
                ),
              ),
            ),
            if (widget.bottomWidget != null)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: widget.backgroundColor ?? Colors.white,
                      child: widget.bottomWidget!,
                    ),
                  ),
                ],
              ),
            Container(
              height: 0.5.fh,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
