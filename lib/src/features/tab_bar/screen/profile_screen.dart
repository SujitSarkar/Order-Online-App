import 'package:flutter/Material.dart';
import '../../../../core/widgets/loading_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingWidget()),
    );
  }
}
