import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/core/constants/text_size.dart';
import 'package:order_online_app/core/widgets/loading_widget.dart';
import 'package:order_online_app/core/widgets/outline_button.dart';
import 'package:order_online_app/core/widgets/solid_button.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:order_online_app/src/features/home/widget/drawer_widget.dart';
import 'package:order_online_app/src/features/home/widget/video_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/web_endpoint.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final HomeProvider homeProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeProvider.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false, // Allow popping by default
      onPopInvoked: (value)async{
        if(homeProvider.canPop()){
          Navigator.pop(context);
        }else{
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
          title: const Text(AppString.appName,style: TextStyle(color: Colors.white,fontSize: 24)),
            iconTheme: const IconThemeData(color: Colors.white)),
        endDrawer: Drawer(
          backgroundColor: Colors.black54,
          width: size.width,
          child: const DrawerWidget(),
        ),
        body: homeProvider.loading
            ? const Center(child: LoadingWidget())
            : RefreshIndicator(
          backgroundColor: Colors.white,
              onRefresh: ()async=> await homeProvider.onRefresh(),
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      homeProvider.settingsDataModel?.data!.sliderVidEnable!=null
                          && homeProvider.settingsDataModel?.data!.sliderVidEnable==true
                          ? VideoWidget(videoUrl: homeProvider.settingsDataModel?.data!.sliderVid??'')
                      :CarouselSlider(
                          options: CarouselOptions(
                            height: size.height*.4,
                            autoPlay: true,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 1,
                          ),
                          items: homeProvider.sliderImageUrlList.map((mediaUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: double.infinity,
                                  height: size.height*.4,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: CachedNetworkImage(
                                      imageUrl: mediaUrl,
                                      placeholder: (context, url) => Container(
                                            width: double.infinity,
                                            height: size.height*.4,
                                            color: Colors.grey.shade300),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              width: double.infinity,
                                              height: size.height*.4,
                                              color: Colors.grey.shade300),
                                      width: double.infinity,
                                      height: size.height*.4,
                                      fit: BoxFit.cover),
                                );
                              },
                            );
                          }).toList(),
                        ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Welcome to',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const Text(AppString.appName,
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const Text('Best Quality And Tasty Food',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                if(homeProvider.settingsDataModel?.data!.orderStatus!=null
                                    && homeProvider.settingsDataModel?.data!.orderStatus==true)
                                  Expanded(
                                    child: SolidButton(
                                        onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                                        child: const Text('Order Online',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                TextSize.buttonText,
                                                fontWeight:
                                                FontWeight.bold))),
                                  ),
                                const SizedBox(width: 12),
                                if(homeProvider.settingsDataModel?.data!.reservationStatus!=null
                                    && homeProvider.settingsDataModel?.data!.reservationStatus==true)
                                  Expanded(
                                    child: OutlineButton(
                                      onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.reservationUrl),
                                      child: const Text('Book A Table',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              TextSize.buttonText,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                    //             fontWeight: FontWeight.bold))),
                                  )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        ///Award
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: InkWell(
                            onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.awards),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/award.jpg',
                                  width: size.width,
                                  height: size.height * .3,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height * .3,
                                  color: Colors.black.withOpacity(0.4),
                                  child: const Text(
                                    'Award',
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

                        ///Gallery
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: InkWell(
                            onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.gallery),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/gallery.jpg',
                                  width: size.width,
                                  height: size.height * .3,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height * .3,
                                  color: Colors.black.withOpacity(0.4),
                                  child: const Text(
                                    'Gallery',
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

                        ///My Order
                        if(homeProvider.settingsDataModel?.data!.orderStatus!=null
                            && homeProvider.settingsDataModel?.data!.orderStatus==true)
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: InkWell(
                            onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/cart.jpg',
                                  width: size.width,
                                  height: size.height * .3,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height * .3,
                                  color: Colors.black.withOpacity(0.4),
                                  child: const Text(
                                    'My Order',
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
                onTap: ()=>homeProvider.navigateToWebPage(''),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_list,color: Colors.white),
                    Text('Menu',style: TextStyle(color: Colors.white))
                  ],
                ),
              ),

              InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.orderUrl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.shopping_cart,color: Colors.grey.shade400),
                    Text('Order',style: TextStyle(color: Colors.grey.shade400))
                  ],
                ),
              ),

              InkWell(
                onTap: ()=>homeProvider.navigateToWebPage(WebEndpoint.profileUrl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_fill,color: Colors.grey.shade400),
                    Text('Profile',style: TextStyle(color: Colors.grey.shade400))
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
