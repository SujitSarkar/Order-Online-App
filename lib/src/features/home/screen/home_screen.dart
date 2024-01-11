import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/Material.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/core/constants/text_size.dart';
import 'package:order_online_app/core/widgets/loading_widget.dart';
import 'package:order_online_app/core/widgets/outline_button.dart';
import 'package:order_online_app/core/widgets/solid_button.dart';
import 'package:order_online_app/src/features/authentication/repository/auth_repository.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/web_endpoint.dart';
import '../../../../core/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final HomeProvider homeProvider = Provider.of(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeProvider.initialize();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: AppColor.cardColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()async{
            await AuthRepository().logout();
          },
          icon: const Icon(Icons.power_settings_new),
        ),
      ),
      body: SafeArea(
          child: homeProvider.loading
              ? const Center(child: LoadingWidget())
              : CarouselSlider(
                  options: CarouselOptions(
                    height: double.infinity,
                    autoPlay: true,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 1,
                  ),
                  items: homeProvider.sliderImageUrlList.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration:
                              const BoxDecoration(color: AppColor.cardColor),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity),
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
                                        Expanded(
                                          child: SolidButton(
                                              onTap: () {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        AppRouter.webViewPage,
                                                        arguments: WebEndpoint
                                                            .orderUrl,
                                                        (route) => false);
                                              },
                                              child: const Text('Order Online',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          TextSize.buttonText,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: OutlineButton(
                                            onTap: () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  AppRouter.webViewPage,
                                                  arguments: WebEndpoint
                                                      .reservationUrl,
                                                  (route) => false);
                                            },
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
                        );
                      },
                    );
                  }).toList(),
                )),
    );
  }
}
