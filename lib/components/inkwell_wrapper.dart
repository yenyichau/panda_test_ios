// Project imports:
import '../../imports.dart';

class InkWellWrapper extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final bool hapticEnabled;

  const InkWellWrapper(
      {super.key, required this.child, this.onTap, this.hapticEnabled = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }

              onTap!();
            }
          : null,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: child,
    );
  }
}
