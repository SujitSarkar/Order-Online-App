import 'package:flutter/Material.dart';

import '../constants/app_color.dart';

class NormalCard extends StatelessWidget {
  const NormalCard(
      {Key? key,
      required this.child,
      this.bgColor,
      this.borderRadius,
      this.padding})
      : super(key: key);
  final Widget child;
  final Color? bgColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? AppColor.cardColor,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
      elevation: 0.0,
      child: Container(
        padding: padding ?? const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        ),
        child: child,
      ),
    );
  }
}
