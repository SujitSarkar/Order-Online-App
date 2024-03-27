import 'package:flutter/material.dart';

class MaskWidget extends StatelessWidget {
  const MaskWidget({super.key,required this.child, required this.height});
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: child,
    );
  }
}
