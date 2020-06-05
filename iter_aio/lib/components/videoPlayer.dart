import 'dart:async';

// import 'package:html/parser.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/services.dart';
// import 'package:neeko/neeko.dart';
// import 'package:chewie/src/chewie_player.dart';
// import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiredash/wiredash.dart';

class WebPageVideo extends StatefulWidget {
  String link, title;
  WebPageVideo(this.title, this.link);

  @override
  _WebPageVideoState createState() => _WebPageVideoState();
}

class _WebPageVideoState extends State<WebPageVideo> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  var loadingPage = true;

  num position = 1;

  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.link);
    return Scaffold(
      appBar: MediaQuery.of(context).orientation.index == 0
          ? AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                  icon: new Icon(Icons.open_in_browser),
                  onPressed: () {
                    _launchURL(widget.link);
                  },
                  tooltip: 'Open in Browser',
                ),
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
      body: IndexedStack(index: position, children: <Widget>[
        WebView(
          initialUrl: widget.link,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          // onWebViewCreated: (WebViewController webViewController) {
          //   _controller.complete(webViewController);
          //   });
          // },
          key: key,
          onPageFinished: doneLoading,
          onPageStarted: startLoading,
        ),
        Container(
          // color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(height: 200, child: loading()),
              ),
              Center(child: Text('Getting Video ready for you.')),
            ],
          ),
        ),
      ]),
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

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  _launchURL(String url) async {
    // const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
  }
}

// class VideoApp extends StatefulWidget {
//   String url, title;
//   VideoApp(this.title, this.url);
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   // TargetPlatform _platform;
//   VideoPlayerController _videoPlayerController1;
//   VideoPlayerController _videoPlayerController2;
//   ChewieController _chewieController;
//   // double aspectratio;

//   // void getDetailsVideo() async {
//   //   final resp = await http.get(widget.url);
//   //   print(resp.statusCode);
//   //   if (resp.statusCode == 200) {
//   //     var doc = parse(resp.body);
//   //     var body = doc.querySelector('video').innerHtml;
//   //     print(body);
//   //     // body.
//   //   }
//   // }

//   @override
//   initState() {
//     print(widget.url);
//     // getDetailsVideo();
//     super.initState();
//     // aspectratio = null;
//     _videoPlayerController1 = VideoPlayerController.network(widget.url);
//     _videoPlayerController2 = VideoPlayerController.network(widget.url);
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1,
//       aspectRatio: _videoPlayerController1.value.aspectRatio,
//       autoPlay: true,
//       looping: true,
//       allowFullScreen: true,
//       showControlsOnInitialize: true,
//       // Try playing around with some of these other options:

//       // showControls: true,
//       // materialProgressColors: ChewieProgressColors(
//       //   playedColor: Colors.red,
//       //   handleColor: Colors.blue,
//       //   backgroundColor: Colors.grey,
//       //   bufferedColor: Colors.lightGreen,
//       // ),
//       // placeholder: Container(
//       //   width: MediaQuery.of(context).size.width,
//       //   color: Colors.grey,
//       // ),
//       autoInitialize: true,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(errorMessage),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ITER AIO'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(11.0),
//             child: Center(
//               child: Text(
//                 widget.title,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Chewie(
//                 controller: _chewieController,
//               ),
//             ),
//           ),
//           // FlatButton(
//           //   onPressed: () {
//           //     setState(() {
//           //       aspectratio == 1 / 2 ? (3 / 2) : (1 / 2);
//           //       _chewieController.as;
//           //     });
//           //   },
//           //   child: Text('Change Aspect Ratio'),
//           // ),
//           FlatButton(
//             onPressed: () {
//               _chewieController.enterFullScreen();
//             },
//             child: Text('Fullscreen'),
//           ),
//         ],
//       ),
//     );
//   }
// }
