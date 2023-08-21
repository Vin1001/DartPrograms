import 'package:flutter/material.dart';
import 'package:youtube_app/screens/videoplayer.dart';
import 'package:youtube_app/services/vidclient.dart';
import 'package:youtube_app/services/vidsmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  VidClient vc = VidClient();
  late Future<List<dynamic>> _futureVids;

  Future<List<VideoModel>> _getvidsfromAPI() async {
    List<dynamic> vidlist = await vc.getVidsFromClient();
    List<VideoModel> finalVids = toVideoModel(vidlist);
    //print(vidlist);
    //print("NOW RETURNING NULL");
    return finalVids;
  }

  toVideoModel(List<dynamic> list) {
    List<VideoModel> convertedVids = list.map((element) {
      VideoModel vid = VideoModel.extractDataFromJSON(element);
      return vid;
    }).toList();

    return convertedVids;
  }

  @override
  void initState() {
    super.initState();
    _futureVids = _getvidsfromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: Image.asset("assets/ytlogo.png"),
              title: const Text(
                "YouTube",
                style: TextStyle(fontSize: 22),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cast),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications),
                  iconSize: 25,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  iconSize: 25,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle_sharp,
                  ),
                  iconSize: 25,
                ),
              ],
            ),
            //bottomNavigationBar: BottomNavigationBar(items: items),
            body: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                child: FutureBuilder(
                    future: _futureVids,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text("ERROR : ${snapshot.error}"),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              VideoModel video =
                                  snapshot.data!.elementAt(index);
                              List<VideoModel> eles =
                                  snapshot.data!.map((element) {
                                VideoModel ele = element;
                                return ele;
                              }).toList();
                              return GestureDetector(
                                onTap: () {
                                  //video.isTapped = !video.isTapped;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => VideoPLayer(
                                                currentVidIndex: index,
                                                fullList: eles,
                                                // artwork: ele.artworkurl100,
                                                // trackName: ele.trackName,
                                                // artistName: ele.artistName,
                                                // previewUrl: ele.previewUrl,
                                                // isPLaying: ele.isplaying,
                                              )));
                                },
                                child: SizedBox(
                                  //height: MediaQuery.of(context).size.height * 0.33,
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(video
                                                    .thumbnailurls.maxresurl),
                                                fit: BoxFit.fill)),
                                      ),
                                      ListTile(
                                        title: Text(video.title),
                                        subtitle: Text(video.channelName),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return const Placeholder();
                    }),
              ),
            )));
  }
}
