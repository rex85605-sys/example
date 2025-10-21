# YouTube App with Custom InnerTube API

This Flutter app implements YouTube functionality using a custom InnerTube API client instead of the youtube_explode_dart dependency.

## Features

- **Video Search**: Search for YouTube videos with pagination support
- **Trending Videos**: Browse trending content with infinite scroll
- **Video Playback**: Extract stream URLs for video playback
- **Modern UI**: Clean Material Design interface

## Architecture

### Services
- `InnerTubeClient`: Direct interface to YouTube's InnerTube API endpoints
- `YouTubeService`: Public API that maintains compatibility with existing screens

### Models
- `Video`: Data structure for video information (id, title, thumbnail, etc.)
- `VideoSearchList`: Container for video lists with pagination support

### Screens
- `HomeScreen`: Displays trending videos with infinite scroll
- `SearchScreen`: Video search functionality with pagination
- `PlayerScreen`: Video player interface (placeholder implementation)

## API Endpoints Used

- `https://www.youtube.com/youtubei/v1/search` - Video search
- `https://www.youtube.com/youtubei/v1/browse` - Trending/browse content  
- `https://www.youtube.com/youtubei/v1/player` - Stream URL extraction

## Key Features

### Pagination Support
- Uses YouTube's continuation tokens for seamless pagination
- Infinite scroll on both home and search screens
- Efficient loading of additional content

### Error Handling
- Graceful error handling for API failures
- Retry mechanisms for failed requests
- User-friendly error messages

### Stream URL Extraction
- Prioritizes muxed streams (video + audio)
- Fallback to adaptive formats when needed
- Quality-based stream selection

## Dependencies

- `http: ^1.1.0` - HTTP client for API requests
- `flutter` - Flutter framework

## Setup

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## Note

This implementation uses YouTube's internal InnerTube API. The API key and endpoints are publicly available but usage should comply with YouTube's Terms of Service.