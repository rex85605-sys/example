import 'video.dart';

class VideoSearchList {
  final List<Video> videos;
  final String? continuationToken;
  final bool hasMore;
  final String? query; // For search results
  final String? browseId; // For browse results (trending, etc.)

  const VideoSearchList({
    required this.videos,
    this.continuationToken,
    this.hasMore = false,
    this.query,
    this.browseId,
  });

  VideoSearchList copyWith({
    List<Video>? videos,
    String? continuationToken,
    bool? hasMore,
    String? query,
    String? browseId,
  }) {
    return VideoSearchList(
      videos: videos ?? this.videos,
      continuationToken: continuationToken ?? this.continuationToken,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      browseId: browseId ?? this.browseId,
    );
  }

  /// Create a new list by appending more videos (for pagination)
  VideoSearchList append(VideoSearchList other) {
    return copyWith(
      videos: [...videos, ...other.videos],
      continuationToken: other.continuationToken,
      hasMore: other.hasMore,
    );
  }

  @override
  String toString() {
    return 'VideoSearchList(videos: ${videos.length}, hasMore: $hasMore, query: $query)';
  }
}