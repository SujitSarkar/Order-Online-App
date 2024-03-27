import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../src/features/home/provider/home_provider.dart';
import '../../../../src/features/home/widget/drawer_widget.dart';
import '../../../../src/features/home/widget/home_card_widget.dart';
import '../../../../shared/api/web_endpoint.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/card_placeholder_widget.dart';
import '../../../../shared/api/api_endpoint.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false, // Allow popping by default
      onPopInvoked: (value) async {
        if (homeProvider.canPop()) {
          Navigator.pop(context);
        } else {
          final shouldExit = await homeProvider.appExitDialog(context);
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.homeBodyBg,
        appBar: AppBar(
          title: Text(
              homeProvider.loginResponseModel?.data?.accessToken == null
                  ? ''
                  : AppString.appName,
              style: const TextStyle(
                  color: Colors.white, fontSize: TextSize.largeTitleText)),
          iconTheme: const IconThemeData(color: Colors.white),
          titleSpacing: 8.0,
        ),
        drawer: const DrawerWidget(),
        body: homeProvider.loading
            ? const Center(child: LoadingWidget())
            : Column(
                children: [
                  ///Header
                  if (homeProvider.loginResponseModel?.data?.accessToken ==
                      null)
                    Container(
                      color: AppColor.disableColor,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 16),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: TextSize.titleText,
                                    fontWeight: FontWeight.w100),
                              ),
                              Text(
                                AppString.appName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: TextSize.largeTitleText,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                          SolidButton(
                              width: 100,
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.signIn,
                                    arguments: AppString.fromPageList.first);
                              },
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: TextSize.buttonText)))
                        ],
                      ),
                    ),
                  SizedBox(
                      height:
                          homeProvider.loginResponseModel?.data?.accessToken ==
                                  null
                              ? 10
                              : 16),

                  ///Body
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: AppColor.homeBodyBg,
                      onRefresh: () async => await homeProvider.onRefresh(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // homeProvider.settingsDataModel?.data!.sliderVidEnable !=
                              //             null && homeProvider.settingsDataModel?.data!.sliderVidEnable == true
                              //     ? SizedBox(
                              //         height: size.height * .35,
                              //         child: VideoWidget(
                              //             videoUrl: homeProvider.settingsDataModel
                              //                     ?.data!.sliderVid ?? ''))
                              //     :
                              ///Slider
                              InkWell(
                                onTap: () => homeProvider.navigateToWebPage(''),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: size.height * .25,
                                      autoPlay: true,
                                      scrollDirection: Axis.horizontal,
                                      viewportFraction: 1,
                                    ),
                                    items: homeProvider.sliderImageUrlList
                                        .map((mediaUrl) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: double.infinity,
                                            height: size.height * .25,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: mediaUrl,
                                              width: double.infinity,
                                              height: size.height * .25,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  CardPlaceholderWidget(
                                                      height:
                                                          size.height * .25),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  CardPlaceholderWidget(
                                                      height:
                                                          size.height * .25),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (homeProvider.settingsDataModel != null)
                            Column(
                              children: [
                                ///Order Online
                                if (homeProvider.settingsDataModel!.data!
                                    .orderStatus.isEnabled)
                                  HomeCardWidget(
                                    onTap: () async {
                                      if (homeProvider.settingsDataModel!.data!
                                          .redirectLinkOrder!.isLinkValidate) {
                                        await openUrlOnExternal(homeProvider
                                            .settingsDataModel!
                                            .data!
                                            .redirectLinkOrder!);
                                      } else {
                                        homeProvider.navigateToWebPage(
                                            WebEndpoint.orderUrl);
                                      }
                                    },
                                    imageUrl:
                                        '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgOrder!}',
                                    title: 'ORDER ONLINE',
                                  ),
                                if (homeProvider.settingsDataModel!.data!
                                    .orderStatus.isEnabled)
                                  const SizedBox(height: 20),

                                ///Reservation
                                if (homeProvider.settingsDataModel!.data!
                                    .reservationStatus.isEnabled)
                                  HomeCardWidget(
                                    onTap: () async {
                                      if (homeProvider
                                          .settingsDataModel!
                                          .data!
                                          .redirectLinkReservation!
                                          .isLinkValidate) {
                                        await openUrlOnExternal(homeProvider
                                            .settingsDataModel!
                                            .data!
                                            .redirectLinkReservation!);
                                      } else {
                                        homeProvider.navigateToWebPage(
                                            WebEndpoint.reservationUrl);
                                      }
                                    },
                                    imageUrl:
                                        '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgReservation!}',
                                    title: 'RESERVATION',
                                  ),
                                if (homeProvider.settingsDataModel!.data!
                                    .reservationStatus.isEnabled)
                                  const SizedBox(height: 20),

                                ///Offers
                                HomeCardWidget(
                                  onTap: () => homeProvider
                                      .navigateToWebPage(WebEndpoint.orderUrl),
                                  imageUrl:
                                      '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgOffer!}',
                                  title: 'OFFERS',
                                ),
                                const SizedBox(height: 20),

                                ///Loyalty Points
                                if (homeProvider.settingsDataModel!.data!
                                    .pointsEnabled.isEnabled)
                                  HomeCardWidget(
                                    onTap: () => homeProvider.navigateToWebPage(
                                        WebEndpoint.profileUrl),
                                    imageUrl:
                                        '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgPoints!}',
                                    title: 'LOYALTY POINTS',
                                  ),
                                if (homeProvider.settingsDataModel!.data!
                                    .pointsEnabled.isEnabled)
                                  const SizedBox(height: 20),

                                ///My Orders
                                HomeCardWidget(
                                  onTap: () => homeProvider.navigateToWebPage(
                                      WebEndpoint.orderHistoryUrl),
                                  imageUrl:
                                      '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgMyOrder!}',
                                  title: 'MY ORDERS',
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: Container(
          color: AppColor.secondaryColor,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => homeProvider.navigateToWebPage(''),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_list, color: Colors.white),
                    Text('Menu', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              InkWell(
                onTap: () =>
                    homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.shopping_cart,
                        color: Colors.grey.shade400),
                    Text('Order', style: TextStyle(color: Colors.grey.shade400))
                  ],
                ),
              ),
              InkWell(
                onTap: () =>
                    homeProvider.navigateToWebPage(WebEndpoint.profileUrl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_fill,
                        color: Colors.grey.shade400),
                    Text('Profile',
                        style: TextStyle(color: Colors.grey.shade400))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
