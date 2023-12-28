import 'package:flutter/Material.dart';

import '../../../../core/widgets/loading_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingWidget()),
    );
  }
}
