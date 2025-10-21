import '../models/video.dart';
import '../models/video_search_list.dart';
import 'innertube_client.dart';

class YouTubeService {
  late final InnerTubeClient _client;
  
  YouTubeService() {
    _client = InnerTubeClient();
  }

  /// Search for videos with pagination support
  Future<VideoSearchList> searchVideosPaged(String query) async {
    try {
      return await _client.searchVideos(query);
    } catch (e) {
      print('Error searching videos: $e');
      return const VideoSearchList(videos: []);
    }
  }

  /// Get the next page of results for a given VideoSearchList
  Future<VideoSearchList> nextPage(VideoSearchList current) async {
    if (!current.hasMore || current.continuationToken == null) {
      return current; // No more pages available
    }

    try {
      VideoSearchList nextPageResults;
      
      if (current.query != null) {
        // This is a search result, get next search page
        nextPageResults = await _client.searchVideos(
          current.query!,
          continuationToken: current.continuationToken,
        );
      } else if (current.browseId != null) {
        // This is a browse result, get next browse page
        nextPageResults = await _client.browseVideos(
          browseId: current.browseId!,
          continuationToken: current.continuationToken,
        );
      } else {
        // Fallback to treating as search if we can't determine the type
        return current;
      }

      // Append the new results to the current list
      return current.append(nextPageResults);
      
    } catch (e) {
      print('Error getting next page: $e');
      return current; // Return current list on error
    }
  }

  /// Map videos from a VideoSearchList (for compatibility with existing code)
  List<Video> mapVideos(VideoSearchList list) {
    return list.videos;
  }

  /// Get trending videos with pagination support
  Future<VideoSearchList> getTrendingPaged() async {
    try {
      return await _client.browseVideos(browseId: 'FEtrending');
    } catch (e) {
      print('Error getting trending videos: $e');
      return const VideoSearchList(videos: []);
    }
  }

  /// Get stream URL for a video by its ID
  Future<String?> getStreamUrl(String videoId) async {
    try {
      return await _client.getStreamUrl(videoId);
    } catch (e) {
      print('Error getting stream URL: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.dispose();
  }
}