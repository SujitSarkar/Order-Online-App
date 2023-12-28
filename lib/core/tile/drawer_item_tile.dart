import 'package:flutter/Material.dart';
import '../constants/text_size.dart';

class DrawerItemTile extends StatelessWidget {
  const DrawerItemTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onTap});
  final Function() onTap;
  final IconData leadingIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        color: Colors.grey,
      ),
      title: Text(title, style: const TextStyle(fontSize: TextSize.bodyText)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 10.0,
      minVerticalPadding: 0.0,
      dense: true,
    );
  }
}
