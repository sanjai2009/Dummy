import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyVideoCarousel(),
    );
  }
}

class MyVideoCarousel extends StatefulWidget {
  @override
  _MyVideoCarouselState createState() => _MyVideoCarouselState();
}

class _MyVideoCarouselState extends State<MyVideoCarousel> {
  List<String> videoUrls = [
    'https://player.vimeo.com/progressive_redirect/playback/732430321/rendition/360p/file.mp4',
    'https://player.vimeo.com/progressive_redirect/playback/732430321/rendition/360p/file.mp4',
    'https://player.vimeo.com/progressive_redirect/playback/732430321/rendition/360p/file.mp4',
    // Add more video URLs or file paths here
  ];

  List<ChewieController> chewieControllers = [];

  @override
  void initState() {
    super.initState();
    for (String videoUrl in videoUrls) {
      VideoPlayerController videoPlayerController = VideoPlayerController.network(videoUrl);

      chewieControllers.add(
        ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,
        ),
      );

      // Initialize the video player controller
      videoPlayerController.initialize().then((_) {
        // Ensure the first video is ready to play
        setState(() {});
      }).catchError((error) {
        print("Video Initialization Error: $error");
      });
    }
  }

  @override
  void dispose() {
    for (ChewieController chewieController in chewieControllers) {
      chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Carousel'),
      ),
      body: CarouselSlider.builder(
        itemCount: videoUrls.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          if (chewieControllers[index].videoPlayerController.value.isInitialized) {
            return Chewie(controller: chewieControllers[index]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 0.85,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
