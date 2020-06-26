import 'package:flutter/services.dart';
import 'package:networkvideos/Networking/data.dart';
import 'package:networkvideos/main.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final Data data;

  const Player({Key key, this.data}) : super(key: key);
  @override
  _PlayerState createState() => _PlayerState(data);
}

class _PlayerState extends State<Player> {
  final Data data;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  _PlayerState(this.data);

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      data.sources,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (MediaQuery.of(context).orientation != Orientation.landscape)?AppBar(
        title: Text(data.title),
      ):null,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(_controller,),

                        _PlayPauseOverlay(controller: _controller,onTap: (){
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },),
                        VideoProgressIndicator(_controller, allowScrubbing: true),
                      ],
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Row(
              children: <Widget>[
                IconButton(icon:  Icon(
                  Icons.skip_previous
                  ,size: 30,
                ),onPressed: (){
                  setState(() {

                    _controller.pause();
                    if(data_.elementAt(ind).title==data.title)
                    {
                      ind=(ind==0)?data_.length-1:ind-1;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(ind),)));
                    }
                    else
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(ind),)));

                  });
                },),
                SizedBox(
                  width: 5,
                ),
                IconButton(icon:  Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,size: 30,
                ),onPressed: (){
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                },),
                SizedBox(
                  width: 5,
                ),
                IconButton(icon:  Icon(
                  Icons.skip_next
                  ,size: 30,
                ),onPressed: (){
                  setState(() {
                    _controller.pause();
                    if(data_.elementAt(ind).title==data.title)
                      {
                        ind=(ind==(data_.length-1))?0:ind+1;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(ind),)));
                      }
                    else
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(ind),)));

                  });
                },),
                Spacer(),
                IconButton(icon: Icon(Icons.fullscreen,size: 30,),onPressed: (){
                  (MediaQuery.of(context).orientation == Orientation.landscape)?
                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]):
                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                }),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xffffffff)),),
                  Text(data.subtitle,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xffffffff)),),
                  SizedBox(
                    height: 50,
                  ),
                  Text(data.description),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: data_.length,
                  physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if(data_.elementAt(index).title==data.title)
                    return SizedBox();
                  return GestureDetector(
                    onTap: (){
                      _controller.pause();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(index),)));
                    },
                    child: Container(
                      color: Color(0xff2A2C36),
                      height: 100,
                      width: 300,
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(image: NetworkImage(data_.elementAt(index).thumb),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text("${data_.elementAt(index).title}",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),),

                                Text("${data_.elementAt(index).subtitle}",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            )
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          // Wrap the play or pause in a call to `setState`. This ensures the
//          // correct icon is shown.
//          setState(() {
//            // If the video is playing, pause it.
//            if (_controller.value.isPlaying) {
//              _controller.pause();
//            } else {
//              // If the video is paused, play it.
//              _controller.play();
//            }
//          });
//        },
//        // Display the correct icon depending on the state of the player.
//        child: Icon(
//          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//        ),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller, this.onTap}) : super(key: key);

  final VideoPlayerController controller;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
        ),
      ],
    );
  }
}
