import 'package:flutter/Material.dart';

class CardPlaceholderWidget extends StatelessWidget {
  const CardPlaceholderWidget({super.key,required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
    );
  }
}
