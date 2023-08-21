import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_app/services/vidsmodel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class VideoPLayer extends StatefulWidget {
  late int currentVidIndex;
  late List<VideoModel> fullList;
  VideoPLayer(
      {super.key, required this.currentVidIndex, required this.fullList});
  @override
  _VideoPLayerState createState() => _VideoPLayerState();
}

class _VideoPLayerState extends State<VideoPLayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  // ignore: unused_field
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  //double _volume = 100;
  //bool _muted = false;
  bool _isPlayerReady = false;

  late List<String> _ids;
  // 'nPt8bK2gbaU',
  // 'gQDByCdjUXw',
  // 'iLnmTe5Q2Qw',
  // '_WoCV4c6XOE',
  // 'KmzdUe0RSJo',
  // '6jZDSSZZxjQ',
  // 'p2lYr3vM_1w',
  // '7QUtEmBT_-w',
  // '34_PXCzGw1M',

  @override
  void initState() {
    super.initState();
    _ids = widget.fullList.map((e) {
      String vidurl = e.vidurl;
      return vidurl;
    }).toList();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.elementAt(widget.currentVidIndex),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              //log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          print("THIS IS THE CURRENT VIDEO: ${widget.currentVidIndex}");
          _controller.load(_ids[widget.currentVidIndex]);
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => SafeArea(
        child: SafeArea(
          child: Scaffold(
            // appBar: AppBar(
            //   leading: Padding(
            //     padding: const EdgeInsets.only(left: 12.0),
            //     child: Image.asset(
            //       'assets/ytlogo.png',
            //       fit: BoxFit.fitWidth,
            //     ),
            //   ),
            //   title: const Text(
            //     'Youtube Player Flutter',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   actions: [
            //     IconButton(
            //         icon: const Icon(Icons.video_library),
            //         onPressed: () {} // => Navigator.push(
            //         //   context,
            //         //   CupertinoPageRoute(
            //         //     builder: (context) => VideoList(),
            //         //   ),
            //         // ),
            //         ),
            //   ],
            // ),
            body: Stack(children: [
              ListView.builder(
                  itemCount: widget.fullList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        //setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VideoPLayer(
                                      currentVidIndex: index,
                                      fullList: widget.fullList,
                                      // artwork: ele.artworkurl100,
                                      // trackName: ele.trackName,
                                      // artistName: ele.artistName,
                                      // previewUrl: ele.previewUrl,
                                      // isPLaying: ele.isplaying,
                                    )));
                      },
                      child: Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.fullList
                                          .elementAt(index)
                                          .thumbnailurls
                                          .maxresurl),
                                      fit: BoxFit.fill)),
                            ),
                            ListTile(
                              tileColor: Colors.black,
                              title:
                                  Text(widget.fullList.elementAt(index).title),
                              subtitle: Text(
                                  widget.fullList.elementAt(index).channelName),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        player,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _space,
                              _text('', _videoMetaData.title, 20),
                              _space,
                              Row(
                                children: [
                                  _text('', _videoMetaData.author, 18),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        if (widget.fullList
                                            .elementAt(widget.currentVidIndex)
                                            .isubscribed) {
                                          widget.fullList
                                                  .elementAt(widget.currentVidIndex)
                                                  .isNotifOn =
                                              !widget.fullList
                                                  .elementAt(
                                                      widget.currentVidIndex)
                                                  .isNotifOn;
                                        } else {
                                          widget.fullList
                                                  .elementAt(widget.currentVidIndex)
                                                  .isubscribed =
                                              !widget.fullList
                                                  .elementAt(
                                                      widget.currentVidIndex)
                                                  .isubscribed;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(!widget.fullList
                                              .elementAt(widget.currentVidIndex)
                                              .isubscribed
                                          ? Icons.notifications
                                          : widget.fullList
                                                  .elementAt(
                                                      widget.currentVidIndex)
                                                  .isNotifOn
                                              ? Icons.notifications_active
                                              : Icons.notifications_off)),
                                ],
                              ),
                              // _space,
                              //_text('Video Id', _videoMetaData.videoId),
                              // _space,
                              // Column(
                              //   children: _getlist(),
                              // )
                              // ListView.builder(itemBuilder: (context, index) {
                              //   return GestureDetector(
                              //     onTap: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (_) => VideoPLayer(
                              //                     currentVidIndex: index,
                              //                     fullList: widget.fullList,
                              //                     // artwork: ele.artworkurl100,
                              //                     // trackName: ele.trackName,
                              //                     // artistName: ele.artistName,
                              //                     // previewUrl: ele.previewUrl,
                              //                     // isPLaying: ele.isplaying,
                              //                   )));
                              //     },
                              //     child: SizedBox(
                              //       height: MediaQuery.of(context).size.height * 0.4,
                              //       child: Column(
                              //         children: [
                              //           Container(
                              //             height:
                              //                 MediaQuery.of(context).size.height * 0.25,
                              //             decoration: BoxDecoration(
                              //                 shape: BoxShape.rectangle,
                              //                 image: DecorationImage(
                              //                     image: NetworkImage(widget.fullList
                              //                         .elementAt(widget.currentVidIndex)
                              //                         .thumbnailurls
                              //                         .maxresurl),
                              //                     fit: BoxFit.fill)),
                              //           ),
                              //           ListTile(
                              //             title: Text(widget.fullList
                              //                 .elementAt(widget.currentVidIndex)
                              //                 .title),
                              //             subtitle: Text(widget.fullList
                              //                 .elementAt(widget.currentVidIndex)
                              //                 .channelName),
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   );
                              // })
                              // Row(
                              //   children: [
                              //     _text('', _controller.value.playbackQuality ?? '', 10),
                              //     const Spacer(),
                              //     _text('', '${_controller.value.playbackRate}x  ', 10),
                              //   ],
                              // ),
                              // _space,

                              // TextField(
                              //   enabled: _isPlayerReady,
                              //   controller: _idController,
                              //   decoration: InputDecoration(
                              //     border: InputBorder.none,
                              //     hintText: 'Enter youtube \<video id\> or \<link\>',
                              //     fillColor: Colors.blueAccent.withAlpha(20),
                              //     filled: true,
                              //     hintStyle: const TextStyle(
                              //       fontWeight: FontWeight.w300,
                              //       color: Colors.blueAccent,
                              //     ),
                              //     suffixIcon: IconButton(
                              //       icon: const Icon(Icons.clear),
                              //       onPressed: () => _idController.clear(),
                              //     ),
                              //   ),
                              // ),
                              // _space,
                              // Row(
                              //   children: [
                              //     _loadCueButton('LOAD'),
                              //     const SizedBox(width: 10.0),
                              //     _loadCueButton('CUE'),
                              //   ],
                              // ),
                              // _space,
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     IconButton(
                              //       icon: const Icon(Icons.skip_previous),
                              //       onPressed: _isPlayerReady
                              //           ? () => _controller.load(_ids[
                              //               (_ids.indexOf(_controller.metadata.videoId) -
                              //                       1) %
                              //                   _ids.length])
                              //           : null,
                              //     ),
                              //     IconButton(
                              //       icon: Icon(
                              //         _controller.value.isPlaying
                              //             ? Icons.pause
                              //             : Icons.play_arrow,
                              //       ),
                              //       onPressed: _isPlayerReady
                              //           ? () {
                              //               _controller.value.isPlaying
                              //                   ? _controller.pause()
                              //                   : _controller.play();
                              //               setState(() {});
                              //             }
                              //           : null,
                              //     ),
                              //     IconButton(
                              //       icon:
                              //           Icon(_muted ? Icons.volume_off : Icons.volume_up),
                              //       onPressed: _isPlayerReady
                              //           ? () {
                              //               _muted
                              //                   ? _controller.unMute()
                              //                   : _controller.mute();
                              //               setState(() {
                              //                 _muted = !_muted;
                              //               });
                              //             }
                              //           : null,
                              //     ),
                              //     FullScreenButton(
                              //       controller: _controller,
                              //       color: Colors.blueAccent,
                              //     ),
                              //     IconButton(
                              //       icon: const Icon(Icons.skip_next),
                              //       onPressed: _isPlayerReady
                              //           ? () => _controller.load(_ids[
                              //               (_ids.indexOf(_controller.metadata.videoId) +
                              //                       1) %
                              //                   _ids.length])
                              //           : null,
                              //     ),
                              //   ],
                              // ),
                              // _space,
                              // Row(
                              //   children: <Widget>[
                              //     const Text(
                              //       "Volume",
                              //       style: TextStyle(fontWeight: FontWeight.w300),
                              //     ),
                              //     Expanded(
                              //       child: Slider(
                              //         inactiveColor: Colors.transparent,
                              //         value: _volume,
                              //         min: 0.0,
                              //         max: 100.0,
                              //         divisions: 10,
                              //         label: '${(_volume).round()}',
                              //         onChanged: _isPlayerReady
                              //             ? (value) {
                              //                 setState(() {
                              //                   _volume = value;
                              //                 });
                              //                 _controller.setVolume(_volume.round());
                              //               }
                              //             : null,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // _space,
                              // AnimatedContainer(
                              //   duration: const Duration(milliseconds: 800),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(20.0),
                              //     color: _getStateColor(_playerState),
                              //   ),
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //     _playerState.toString(),
                              //     style: const TextStyle(
                              //       fontWeight: FontWeight.w300,
                              //       color: Colors.white,
                              //     ),
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  List<Widget> _getlist() {
    List<Widget> list = widget.fullList.map((e) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VideoPLayer(
                        currentVidIndex: widget.currentVidIndex,
                        fullList: widget.fullList,
                        // artwork: ele.artworkurl100,
                        // trackName: ele.trackName,
                        // artistName: ele.artistName,
                        // previewUrl: ele.previewUrl,
                        // isPLaying: ele.isplaying,
                      )));
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(widget.fullList
                            .elementAt(widget.currentVidIndex)
                            .thumbnailurls
                            .maxresurl),
                        fit: BoxFit.fill)),
              ),
              ListTile(
                title: Text(e.title),
                subtitle: Text(widget.fullList
                    .elementAt(widget.currentVidIndex)
                    .channelName),
              )
            ],
          ),
        ),
      );
    }).toList();
    return list;
  }

  Widget _text(String title, String value, double? fsize) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: fsize,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
