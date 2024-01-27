import 'package:flutter/Material.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/widgets/solid_button.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/web_endpoint.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel_outlined,
                    color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(height: 100),
            InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(''),
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.awards),
                child: const Text(
                  'Awards',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.gallery),
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.contact),
                child: const Text(
                  'Contact',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            SolidButton(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                backgroundColor: Colors.white,
                width: 200,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: const Text(
                  'Order Online',
                  style: TextStyle(fontSize: 24, color: AppColor.primaryColor),
                )),
            const SizedBox(height: 20),
            SolidButton(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.reservationUrl),
                backgroundColor: Colors.white,
                width: 200,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: const Text(
                  'Book A Table',
                  style: TextStyle(fontSize: 24, color: AppColor.primaryColor),
                )),
          ],
        ),
      ),
    );
  }
}
