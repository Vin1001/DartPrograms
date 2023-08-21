import 'package:dio/dio.dart';

class VidClient {
  final Dio _dio = Dio();
  getVidsFromClient() async {
    try {
      print("CALLING....");
      String url =
          'https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics%2Cplayer&chart=mostPopular&maxResults=200&regionCode=IN&key=AIzaSyDIy-EczH3gQZ0BQa85wXkEqS3wghHNnDo';

      var response = await _dio.get(url);

      //print("This is the number of items: ${response.data['items'].runtimeType}");
      return response.data['items'];
    } catch (err) {
      print("SOME ERROR OCCURRED: $err");
    }
  }
}
