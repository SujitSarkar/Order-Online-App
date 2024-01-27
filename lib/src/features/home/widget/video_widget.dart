import 'package:flutter/Material.dart';
import 'package:order_online_app/core/widgets/loading_widget.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..setLooping(true)..initialize()..play();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: controller != null
          ? VideoPlayer(controller!)
          : const Center(
              child: LoadingWidget(),
            ),
    );
  }
}
