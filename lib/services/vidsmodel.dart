class VideoModel {
  late String vidurl;
  late String title;
  late String channelName;
  late Thumbnails thumbnailurls;
  bool isubscribed = false;
  bool isNotifOn = false;
  //bool isTapped = false;

  VideoModel({
    required this.vidurl,
    required this.title,
    required this.channelName,
    required this.thumbnailurls,
  });

  VideoModel.extractDataFromJSON(Map<String, dynamic> vidData) {
    vidurl = vidData['id'] ?? "NA";
    title = vidData['snippet']['title'];
    channelName = vidData['snippet']['channelTitle'];
    thumbnailurls = Thumbnails.extracturls(vidData['snippet']['thumbnails']);
  }
}

class Thumbnails {
  late String defaulturl;
  late String mediumurl;
  late String highurl;
  late String standardurl;
  late String maxresurl;

  Thumbnails({
    required this.defaulturl,
    required this.mediumurl,
    required this.highurl,
    required this.standardurl,
    required this.maxresurl,
  });

  Thumbnails.extracturls(Map<String, dynamic> thmbmap) {
    //print("This is THUMBNAIL; ${thmbmap['standard']}");
    defaulturl = thmbmap['default']['url'] ?? "NA";
    mediumurl = thmbmap['medium']['url'] ?? "NA";
    highurl = thmbmap['high']['url'] ?? "NA";
    standardurl = thmbmap['standard']['url'] ?? "NA";
    if (thmbmap['maxres'] != null) {
      maxresurl = thmbmap['maxres']['url'];
    } else {
      maxresurl = standardurl;
    }
  }
}
