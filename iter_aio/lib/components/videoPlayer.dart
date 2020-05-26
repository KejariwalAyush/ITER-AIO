import 'dart:async';

// import 'package:html/parser.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
// import 'package:neeko/neeko.dart';
// import 'package:chewie/src/chewie_player.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiredash/wiredash.dart';

class WebPageView extends StatefulWidget {
  String link, title;
  WebPageView(this.title, this.link);

  @override
  _WebPageViewState createState() => _WebPageViewState();
}

class _WebPageViewState extends State<WebPageView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  var loadingPage = false;
  @override
  Widget build(BuildContext context) {
    print(widget.link);
    return Scaffold(
      appBar: MediaQuery.of(context).orientation.index == 0
          ? AppBar(
              title: Text('ITER AIO'),
              actions: <Widget>[
                IconButton(
                  icon: new Icon(Icons.feedback),
                  onPressed: () {
                    Wiredash.of(context).show();
                  },
                ),
              ],
              // elevation: 15,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(25),
              //         bottomRight: Radius.circular(25))),
            )
          : null,
      body: Center(
        child: WebView(
          initialUrl: widget.link,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            // setState(() {
            //   loadingPage = _controller.isCompleted;
            // });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SystemChrome.setPreferredOrientations([
            MediaQuery.of(context).orientation.index == 0
                ? DeviceOrientation.landscapeLeft
                : DeviceOrientation.portraitUp,
            // DeviceOrientation.portraitUp,
          ]);
        },
        mini: true,
        child: Icon(Icons.screen_rotation),
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
}

class VideoApp extends StatefulWidget {
  String url, title;
  VideoApp(this.title, this.url);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  // TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  // double aspectratio;

  // void getDetailsVideo() async {
  //   final resp = await http.get(widget.url);
  //   print(resp.statusCode);
  //   if (resp.statusCode == 200) {
  //     var doc = parse(resp.body);
  //     var body = doc.querySelector('video').innerHtml;
  //     print(body);
  //     // body.
  //   }
  // }

  @override
  initState() {
    print(widget.url);
    // getDetailsVideo();
    super.initState();
    // aspectratio = null;
    _videoPlayerController1 = VideoPlayerController.network(widget.url);
    _videoPlayerController2 = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: _videoPlayerController1.value.aspectRatio,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      // Try playing around with some of these other options:

      // showControls: true,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   width: MediaQuery.of(context).size.width,
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          // FlatButton(
          //   onPressed: () {
          //     setState(() {
          //       aspectratio == 1 / 2 ? (3 / 2) : (1 / 2);
          //       _chewieController.as;
          //     });
          //   },
          //   child: Text('Change Aspect Ratio'),
          // ),
          FlatButton(
            onPressed: () {
              _chewieController.enterFullScreen();
            },
            child: Text('Fullscreen'),
          ),
        ],
      ),
    );
  }
}

// class PlayVideo extends StatefulWidget {
//   String title, url;
//   PlayVideo(this.title, this.url);
//   @override
//   _PlayVideoState createState() => _PlayVideoState();
// }

// class _PlayVideoState extends State<PlayVideo> {
//   // static const String beeUri =
//   //     'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4';

//   final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
//       DataSource.network(
//           'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
//           displayName: "displayName"));

// //  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
// //      DataSource.network(
// //          'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
// //          displayName: "displayName"));

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.restoreSystemUIOverlays();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NeekoPlayerWidget(
//         onSkipPrevious: () {
//           print("skip");
//           videoControllerWrapper.prepareDataSource(DataSource.network(
//               "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312083533415853.mp4",
//               displayName: "This house is not for sale"));
//         },
//         onSkipNext: () {
//           videoControllerWrapper.prepareDataSource(DataSource.network(
//               'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
//               displayName: "displayName"));
//         },
//         videoControllerWrapper: videoControllerWrapper,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(
//                 Icons.share,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 print("share");
//               })
//         ],
//       ),
//     );
//   }
// }
