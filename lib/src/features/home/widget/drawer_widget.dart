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
                onPressed: () => Scaffold.of(context).closeEndDrawer(),
                icon: const Icon(Icons.cancel_outlined,
                    color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(height: 100),
            InkWell(
                onTap: () => homeProvider.popAndNavigateToWebPage('',context),
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: () =>
                    homeProvider.popAndNavigateToWebPage(WebEndpoint.awards,context),
                child: const Text(
                  'Awards',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: () =>
                    homeProvider.popAndNavigateToWebPage(WebEndpoint.gallery,context),
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: () =>
                    homeProvider.popAndNavigateToWebPage(WebEndpoint.contact,context),
                child: const Text(
                  'Contact',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            const SizedBox(height: 20),
            if(homeProvider.settingsDataModel?.data!.orderStatus!=null
                && homeProvider.settingsDataModel?.data!.orderStatus==true)
            SolidButton(
                onTap: () =>
                    homeProvider.popAndNavigateToWebPage(WebEndpoint.orderUrl,context),
                backgroundColor: Colors.white,
                width: 200,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: const Text(
                  'Order Online',
                  style: TextStyle(fontSize: 24, color: AppColor.primaryColor),
                )),
            const SizedBox(height: 20),
            if(homeProvider.settingsDataModel?.data!.reservationStatus!=null
                && homeProvider.settingsDataModel?.data!.reservationStatus==true)
            SolidButton(
                onTap: () => homeProvider
                    .popAndNavigateToWebPage(WebEndpoint.reservationUrl,context),
                backgroundColor: Colors.white,
                width: 200,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: const Text(
                  'Reservation',
                  style: TextStyle(fontSize: 24, color: AppColor.primaryColor),
                )),
          ],
        ),
      ),
    );
  }
}
