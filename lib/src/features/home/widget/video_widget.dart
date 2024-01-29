import 'package:flutter/Material.dart';
import 'package:order_online_app/core/constants/app_color.dart';
import 'package:order_online_app/core/widgets/loading_widget.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  @override
  void initState() {
    final HomeProvider homeProvider = Provider.of(context,listen: false);
    homeProvider.initVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    return AspectRatio(
      aspectRatio: homeProvider.videoController.value.aspectRatio,
      child: !homeProvider.loadingVideo && homeProvider.videoController.value.isInitialized
          ? VideoPlayer(homeProvider.videoController)
          : const Center(
              child: LoadingWidget(color: AppColor.primaryColor),
            ),
    );
  }
}
