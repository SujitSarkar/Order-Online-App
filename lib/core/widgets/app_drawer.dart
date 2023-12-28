import 'package:flutter/material.dart';
import '../tile/drawer_item_tile.dart';
import 'normal_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NormalCard(
          child: SingleChildScrollView(
        child: Column(children: [
          // ///Header
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //       color: AppColor.appBodyBg,
          //       borderRadius: BorderRadius.all(Radius.circular(5))),
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         const Icon(Icons.person, size: 42, color: Colors.grey),
          //         Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 tabBarProvider.loginResponseModel!.name!,
          //                 style: const TextStyle(fontSize: TextSize.bodyText),
          //               ),
          //               Text(
          //                 tabBarProvider.loginResponseModel!.email!,
          //                 style: const TextStyle(
          //                     fontSize: TextSize.bodyText, color: Colors.grey),
          //               )
          //             ])
          //       ]),
          // ),
          // const SizedBox(height: 16),
          DrawerItemTile(
              leadingIcon: Icons.logout,
              title: 'Logout',
              onTap: () async {}),
        ]),
      )),
    );
  }
}
