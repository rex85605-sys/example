// Simple validation script to check Dart syntax
import 'lib/models/video.dart';
import 'lib/models/video_search_list.dart';
import 'lib/services/innertube_client.dart';
import 'lib/services/youtube_service.dart';

void main() {
  // Test video model creation
  final video = Video(
    id: 'test123',
    title: 'Test Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
  );
  
  print('Video created: ${video.title}');
  
  // Test video search list creation
  final searchList = VideoSearchList(
    videos: [video],
    hasMore: true,
  );
  
  print('Search list created with ${searchList.videos.length} videos');
  
  // Test service initialization
  final youtubeService = YouTubeService();
  print('YouTube service initialized');
  
  youtubeService.dispose();
  print('Validation completed successfully!');
}