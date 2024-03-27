import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import '../../../../core/widgets/card_placeholder_widget.dart';
import '../../../../core/widgets/mask_widget.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      required this.title});

  final String imageUrl;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: size.height * .25,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  CardPlaceholderWidget(height: size.height * .25),
              errorWidget: (context, url, error) =>
                  CardPlaceholderWidget(height: size.height * .25),
            ),
            MaskWidget(
              height: size.height * .25,
              child: Text(
                title,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    height: 1,
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppString.homeCardFontName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
