import 'package:flutter/Material.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/core/utils/extensions.dart';
import 'package:order_online_app/core/widgets/solid_button.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../../../../shared/api/web_endpoint.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validator.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);

    return Drawer(
      backgroundColor: Colors.black54,
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Scaffold.of(context).closeDrawer(),
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 30),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .08),
                    InkWell(
                        onTap: () =>
                            homeProvider.popAndNavigateToWebPage('', context),
                        child: const Text(
                          'HOME',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                    const SizedBox(height: 28),
                    InkWell(
                        onTap: () => homeProvider.popAndNavigateToWebPage(
                            WebEndpoint.awards, context),
                        child: const Text(
                          'AWARDS',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                    const SizedBox(height: 28),
                    InkWell(
                        onTap: () => homeProvider.popAndNavigateToWebPage(
                            WebEndpoint.gallery, context),
                        child: const Text(
                          'GALLERY',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                    const SizedBox(height: 28),
                    InkWell(
                        onTap: () => homeProvider.popAndNavigateToWebPage(
                            WebEndpoint.contact, context),
                        child: const Text(
                          'CONTACT',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                    const SizedBox(height: 28),
                    homeProvider.loginResponseModel?.data?.accessToken == null
                        ? InkWell(
                            onTap: () {
                              Scaffold.of(context).closeDrawer();
                              Navigator.pushNamed(context, AppRouter.signIn,
                                  arguments: AppString.fromPageList.first);
                            },
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ))
                        : Column(
                          children: [
                            InkWell(
                                onTap: () async {
                                  Scaffold.of(context).closeDrawer();
                                  await homeProvider.logoutButtonOnTap();
                                },
                                child: const Text(
                                  'LOGOUT',
                                  style: TextStyle(color: Colors.white, fontSize: 22),
                                )),
                            const SizedBox(height: 28),

                            InkWell(
                              onTap: (){
                                homeProvider.popAndNavigateToWebPage(
                                    WebEndpoint.profileUrl, context);
                              },
                              child: Container(
                                height: 45,
                                width: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.secondaryColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(color: Colors.white,width: 1)
                                ),
                                child: Text(homeProvider.loginResponseModel!.data!.user!.name![0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white,fontSize: 28),),
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 28),
                    if (homeProvider.settingsDataModel!.data!.orderStatus.isEnabled)
                      SolidButton(
                          onTap: () async {
                            if (homeProvider.settingsDataModel!.data!
                                .redirectLinkOrder!.isLinkValidate) {
                              await openUrlOnExternal(homeProvider
                                  .settingsDataModel!.data!.redirectLinkOrder!);
                            } else {
                              homeProvider.popAndNavigateToWebPage(
                                  WebEndpoint.orderUrl, context);
                            }
                          },
                          backgroundColor: Colors.white,
                          width: 200,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          child: const Text(
                            'Order Online',
                            style: TextStyle(
                                fontSize: 22, color: AppColor.primaryColor),
                          )),
                    const SizedBox(height: 28),
                    if (homeProvider.settingsDataModel!.data!.reservationStatus.isEnabled)
                      SolidButton(
                          onTap: () async{
                            if (homeProvider.settingsDataModel!.data!.redirectLinkReservation!.isLinkValidate) {
                              await openUrlOnExternal(homeProvider.settingsDataModel!.data!.redirectLinkReservation!);
                            } else {
                              homeProvider.popAndNavigateToWebPage(WebEndpoint.reservationUrl,context);
                            }
                          },
                          backgroundColor: Colors.white,
                          width: 200,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          child: const Text(
                            'Reservation',
                            style: TextStyle(
                                fontSize: 22, color: AppColor.primaryColor),
                          )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
