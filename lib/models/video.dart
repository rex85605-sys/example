class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? duration;
  final String? channelName;
  final String? viewCount;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.duration,
    this.channelName,
    this.viewCount,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    // Extract video ID from either videoId or navigationEndpoint
    String videoId = '';
    if (json['videoId'] != null) {
      videoId = json['videoId'];
    } else if (json['navigationEndpoint']?['watchEndpoint']?['videoId'] != null) {
      videoId = json['navigationEndpoint']['watchEndpoint']['videoId'];
    }

    // Extract title from various possible locations
    String title = '';
    if (json['title']?['runs'] != null && json['title']['runs'].isNotEmpty) {
      title = json['title']['runs'][0]['text'] ?? '';
    } else if (json['title']?['simpleText'] != null) {
      title = json['title']['simpleText'];
    }

    // Extract thumbnail URL
    String thumbnailUrl = '';
    if (json['thumbnail']?['thumbnails'] != null && 
        json['thumbnail']['thumbnails'].isNotEmpty) {
      // Get the highest quality thumbnail
      final thumbnails = json['thumbnail']['thumbnails'] as List;
      thumbnailUrl = thumbnails.last['url'] ?? '';
    }

    // Extract additional metadata
    String? duration;
    if (json['lengthText']?['simpleText'] != null) {
      duration = json['lengthText']['simpleText'];
    }

    String? channelName;
    if (json['ownerText']?['runs'] != null && json['ownerText']['runs'].isNotEmpty) {
      channelName = json['ownerText']['runs'][0]['text'];
    } else if (json['shortBylineText']?['runs'] != null && 
               json['shortBylineText']['runs'].isNotEmpty) {
      channelName = json['shortBylineText']['runs'][0]['text'];
    }

    String? viewCount;
    if (json['viewCountText']?['simpleText'] != null) {
      viewCount = json['viewCountText']['simpleText'];
    }

    return Video(
      id: videoId,
      title: title,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      channelName: channelName,
      viewCount: viewCount,
    );
  }

  @override
  String toString() {
    return 'Video(id: $id, title: $title, thumbnailUrl: $thumbnailUrl)';
  }
}