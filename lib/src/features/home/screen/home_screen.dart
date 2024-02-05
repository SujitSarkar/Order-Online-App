import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/core/constants/text_size.dart';
import 'package:order_online_app/core/router/app_router.dart';
import 'package:order_online_app/core/utils/extensions.dart';
import 'package:order_online_app/core/widgets/loading_widget.dart';
import 'package:order_online_app/core/widgets/mask_widget.dart';
import 'package:order_online_app/core/widgets/solid_button.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:order_online_app/src/features/home/widget/drawer_widget.dart';
import 'package:provider/provider.dart';
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
          // ignore: use_build_context_synchronously
          final shouldExit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Do you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      const Text('No', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.cardColor,
        appBar: AppBar(
          title: Text(homeProvider.loginResponseModel?.data?.accessToken==null
              ? ''
              : AppString.appName,
            style: const TextStyle(color: Colors.white,fontSize: TextSize.largeTitleText)),
            iconTheme: const IconThemeData(color: Colors.white),
          titleSpacing: 8.0,
        ),
        drawer: Drawer(
          backgroundColor: Colors.black54,
          width: size.width,
          child: const DrawerWidget(),
        ),
        body: homeProvider.loading
            ? const Center(child: LoadingWidget())
            : RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async => await homeProvider.onRefresh(),
                child: Column(
                  children: [
                    ///Header
                    if(homeProvider.loginResponseModel?.data?.accessToken==null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16,top: 12,right: 16),
                      child: Row(
                        children: [
                          const Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome to',style: TextStyle(fontSize: TextSize.titleText,fontWeight: FontWeight.w100),),
                              Text(AppString.appName,style: TextStyle(fontSize: TextSize.largeTitleText,fontWeight: FontWeight.w500),),
                            ],
                          )),
                          SolidButton(
                            width: 100,
                            onTap: (){
                              Navigator.pushNamed(context, AppRouter.signIn,arguments: AppString.fromPageList.first);
                            },
                              child: const Text('Login',style: TextStyle(color: Colors.white,fontSize: TextSize.buttonText)))
                        ],
                      ),
                    ),
                    if(homeProvider.loginResponseModel?.data?.accessToken==null)
                    const Divider(thickness: 0.5),
                    SizedBox(height: homeProvider.loginResponseModel?.data?.accessToken==null?10:16),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              InkWell(
                                onTap: () => homeProvider.navigateToWebPage(''),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  child: CachedNetworkImage(
                                                      imageUrl: mediaUrl,
                                                      width: double.infinity,
                                                      height: size.height * .25,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                                      errorWidget: (context, url,error) => CardPlaceholderWidget(height: size.height * .25),),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     const Text('Welcome to',
                              //         style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white)),
                              //     const Text(AppString.appName,
                              //         style: TextStyle(
                              //             fontSize: 32,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white)),
                              //     const Text('Best Quality And Tasty Food',
                              //         style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white)),
                              //     const SizedBox(height: 12),
                              //     Padding(
                              //       padding:
                              //           const EdgeInsets.symmetric(horizontal: 16),
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceAround,
                              //         children: [
                              //           if (homeProvider.settingsDataModel?.data!
                              //                       .orderStatus !=
                              //                   null &&
                              //               homeProvider.settingsDataModel?.data!
                              //                       .orderStatus ==
                              //                   true)
                              //             Expanded(
                              //               child: SolidButton(
                              //                   onTap: () =>
                              //                       homeProvider.navigateToWebPage(
                              //                           WebEndpoint.orderUrl),
                              //                   child: const Text('Order Online',
                              //                       style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontSize: TextSize.buttonText,
                              //                           fontWeight:
                              //                               FontWeight.bold))),
                              //             ),
                              //           const SizedBox(width: 12),
                              //           if (homeProvider.settingsDataModel?.data!
                              //                       .reservationStatus !=
                              //                   null &&
                              //               homeProvider.settingsDataModel?.data!
                              //                       .reservationStatus ==
                              //                   true)
                              //             Expanded(
                              //               child: OutlineButton(
                              //                 onTap: () =>
                              //                     homeProvider.navigateToWebPage(
                              //                         WebEndpoint.reservationUrl),
                              //                 child: const Text('Book A Table',
                              //                     style: TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize: TextSize.buttonText,
                              //                         fontWeight: FontWeight.bold)),
                              //               ),
                              //               //             fontWeight: FontWeight.bold))),
                              //             )
                              //         ],
                              //       ),
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                          const SizedBox(height: 20),
                          if(homeProvider.settingsDataModel!=null)
                          Column(
                            children: [
                              ///Order Online
                              if (homeProvider.settingsDataModel?.data!.orderStatus != null &&
                                  homeProvider.settingsDataModel?.data!.orderStatus == true)
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: InkWell(
                                  onTap: ()async{
                                    if(homeProvider.settingsDataModel!.data!.redirectLinkOrder!.isLinkValidate){
                                      await openUrlOnExternal(homeProvider.settingsDataModel!.data!.redirectLinkOrder!);
                                    }else{
                                      homeProvider.navigateToWebPage(WebEndpoint.orderUrl);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgOrder!}',
                                        width: double.infinity,
                                        height: size.height * .25,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                        errorWidget: (context, url, error) => CardPlaceholderWidget(height: size.height * .25),),
                                      MaskWidget(
                                        height: size.height * .25,
                                        child: const Text(
                                          'Order Online',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (homeProvider.settingsDataModel?.data!.orderStatus != null &&
                                  homeProvider.settingsDataModel?.data!.orderStatus == true)
                              const SizedBox(height: 20),

                              ///Reservation
                              if (homeProvider.settingsDataModel?.data!.reservationStatus != null &&
                                  homeProvider.settingsDataModel?.data!.reservationStatus == true)
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: InkWell(
                                  onTap: ()async{
                                    if(homeProvider.settingsDataModel!.data!.redirectLinkReservation!.isLinkValidate){
                                      await openUrlOnExternal(homeProvider.settingsDataModel!.data!.redirectLinkReservation!);
                                    }else{
                                      homeProvider.navigateToWebPage(WebEndpoint.reservationUrl);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgReservation!}',
                                        width: double.infinity,
                                        height: size.height * .25,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                        errorWidget: (context, url, error) => CardPlaceholderWidget(height: size.height * .25),),
                                      MaskWidget(
                                        height: size.height * .25,
                                        child: const Text(
                                          'Reservation',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (homeProvider.settingsDataModel?.data!.reservationStatus != null &&
                                  homeProvider.settingsDataModel?.data!.reservationStatus == true)
                              const SizedBox(height: 20),

                              ///Offers
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: InkWell(
                                  onTap: () => homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgOffer!}',
                                        width: double.infinity,
                                        height: size.height * .25,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                        errorWidget: (context, url, error) => CardPlaceholderWidget(height: size.height * .25),),
                                      MaskWidget(
                                        height: size.height * .25,
                                        child: const Text(
                                          'Offer',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              ///Loyalty Point
                              if (homeProvider.settingsDataModel?.data!.pointsEnabled != null &&
                                  homeProvider.settingsDataModel?.data!.pointsEnabled == true)
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: InkWell(
                                  onTap: () => homeProvider.navigateToWebPage(WebEndpoint.profileUrl),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgPoints!}',
                                        width: double.infinity,
                                        height: size.height * .25,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                        errorWidget: (context, url, error) => CardPlaceholderWidget(height: size.height * .25),),
                                      MaskWidget(
                                        height: size.height * .25,
                                        child: const Text(
                                          'Loyalty Point',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (homeProvider.settingsDataModel?.data!.pointsEnabled != null &&
                                  homeProvider.settingsDataModel?.data!.pointsEnabled == true)
                              const SizedBox(height: 20),

                              ///My Orders
                              ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: InkWell(
                                    onTap: () => homeProvider.navigateToWebPage(WebEndpoint.orderHistoryUrl),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: '${ApiEndpoint.imageUrlPath}/${homeProvider.settingsDataModel!.data!.cardImgMyOrder!}',
                                          width: double.infinity,
                                          height: size.height * .25,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => CardPlaceholderWidget(height: size.height * .25),
                                          errorWidget: (context, url, error) => CardPlaceholderWidget(height: size.height * .25),),
                                        MaskWidget(
                                          height: size.height * .25,
                                          child: const Text(
                                            'My Orders',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                height: 1,
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
