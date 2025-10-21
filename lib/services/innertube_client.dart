import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../models/video_search_list.dart';

class InnerTubeClient {
  static const String _baseUrl = 'https://www.youtube.com/youtubei/v1';
  static const String _apiKey = 'AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8'; // YouTube's web client API key
  
  final http.Client _httpClient;
  
  // Client context for YouTube InnerTube API
  static const Map<String, dynamic> _clientContext = {
    'context': {
      'client': {
        'clientName': 'WEB',
        'clientVersion': '2.20231120.01.00',
        'hl': 'en',
        'gl': 'US',
        'utcOffsetMinutes': 0,
      },
      'user': {
        'lockedSafetyMode': false,
      },
    },
  };

  InnerTubeClient({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  /// Search for videos using the InnerTube search endpoint
  Future<VideoSearchList> searchVideos(String query, {String? continuationToken}) async {
    final url = Uri.parse('$_baseUrl/search?key=$_apiKey');
    
    Map<String, dynamic> body = {
      ..._clientContext,
      'query': query,
    };

    if (continuationToken != null) {
      body['continuation'] = continuationToken;
    }

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseSearchResponse(data, query: query);
      } else {
        throw Exception('Search failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  /// Browse trending videos or other browse content
  Future<VideoSearchList> browseVideos({String browseId = 'FEtrending', String? continuationToken}) async {
    final url = Uri.parse('$_baseUrl/browse?key=$_apiKey');
    
    Map<String, dynamic> body = {
      ..._clientContext,
      'browseId': browseId,
    };

    if (continuationToken != null) {
      body['continuation'] = continuationToken;
    }

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseBrowseResponse(data, browseId: browseId);
      } else {
        throw Exception('Browse failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Browse error: $e');
    }
  }

  /// Get stream URL for a video
  Future<String?> getStreamUrl(String videoId) async {
    final url = Uri.parse('$_baseUrl/player?key=$_apiKey');
    
    final body = {
      ..._clientContext,
      'videoId': videoId,
      'params': '8AEB', // Additional parameters for better stream access
    };

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractStreamUrl(data);
      } else {
        throw Exception('Player request failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Stream URL error: $e');
    }
  }

  /// Parse search response and extract videos
  VideoSearchList _parseSearchResponse(Map<String, dynamic> data, {String? query}) {
    final videos = <Video>[];
    String? continuationToken;
    
    try {
      // Navigate through the response structure
      final contents = data['contents']?['twoColumnSearchResultsRenderer']?['primaryContents']?['sectionListRenderer']?['contents'];
      
      if (contents != null) {
        for (final section in contents) {
          final itemSectionRenderer = section['itemSectionRenderer'];
          if (itemSectionRenderer?['contents'] != null) {
            for (final item in itemSectionRenderer['contents']) {
              if (item['videoRenderer'] != null) {
                try {
                  final video = Video.fromJson(item['videoRenderer']);
                  if (video.id.isNotEmpty && video.title.isNotEmpty) {
                    videos.add(video);
                  }
                } catch (e) {
                  // Skip invalid video entries
                  print('Error parsing video: $e');
                }
              }
            }
          }
        }
      }

      // Look for continuation token
      continuationToken = _extractContinuationToken(data);
      
    } catch (e) {
      print('Error parsing search response: $e');
    }

    return VideoSearchList(
      videos: videos,
      continuationToken: continuationToken,
      hasMore: continuationToken != null,
      query: query,
    );
  }

  /// Parse browse response and extract videos
  VideoSearchList _parseBrowseResponse(Map<String, dynamic> data, {String? browseId}) {
    final videos = <Video>[];
    String? continuationToken;
    
    try {
      // Navigate through the browse response structure
      final tabs = data['contents']?['twoColumnBrowseResultsRenderer']?['tabs'];
      
      if (tabs != null) {
        for (final tab in tabs) {
          final tabRenderer = tab['tabRenderer'];
          if (tabRenderer?['content']?['richGridRenderer']?['contents'] != null) {
            final contents = tabRenderer['content']['richGridRenderer']['contents'];
            
            for (final item in contents) {
              if (item['richItemRenderer']?['content']?['videoRenderer'] != null) {
                try {
                  final video = Video.fromJson(item['richItemRenderer']['content']['videoRenderer']);
                  if (video.id.isNotEmpty && video.title.isNotEmpty) {
                    videos.add(video);
                  }
                } catch (e) {
                  print('Error parsing video: $e');
                }
              }
            }
          }
        }
      }

      // Look for continuation token
      continuationToken = _extractContinuationToken(data);
      
    } catch (e) {
      print('Error parsing browse response: $e');
    }

    return VideoSearchList(
      videos: videos,
      continuationToken: continuationToken,
      hasMore: continuationToken != null,
      browseId: browseId,
    );
  }

  /// Extract continuation token from response
  String? _extractContinuationToken(Map<String, dynamic> data) {
    // Look for continuation tokens in various possible locations
    try {
      // Search response continuation
      final contents = data['contents']?['twoColumnSearchResultsRenderer']?['primaryContents']?['sectionListRenderer']?['contents'];
      if (contents != null) {
        for (final section in contents) {
          if (section['continuationItemRenderer'] != null) {
            return section['continuationItemRenderer']['continuationEndpoint']['continuationCommand']['token'];
          }
        }
      }

      // Browse response continuation
      final tabs = data['contents']?['twoColumnBrowseResultsRenderer']?['tabs'];
      if (tabs != null) {
        for (final tab in tabs) {
          final gridContents = tab['tabRenderer']?['content']?['richGridRenderer']?['contents'];
          if (gridContents != null) {
            for (final item in gridContents) {
              if (item['continuationItemRenderer'] != null) {
                return item['continuationItemRenderer']['continuationEndpoint']['continuationCommand']['token'];
              }
            }
          }
        }
      }

      // OnResponseReceivedActions continuation (common in paginated results)
      final onResponseReceivedActions = data['onResponseReceivedActions'];
      if (onResponseReceivedActions != null) {
        for (final action in onResponseReceivedActions) {
          final continuationItems = action['appendContinuationItemsAction']?['continuationItems'];
          if (continuationItems != null) {
            for (final item in continuationItems) {
              if (item['continuationItemRenderer'] != null) {
                return item['continuationItemRenderer']['continuationEndpoint']['continuationCommand']['token'];
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error extracting continuation token: $e');
    }
    
    return null;
  }

  /// Extract the best stream URL from player response
  String? _extractStreamUrl(Map<String, dynamic> data) {
    try {
      final streamingData = data['streamingData'];
      if (streamingData == null) {
        print('No streaming data available');
        return null;
      }

      // First, try to get muxed streams (video + audio combined)
      final formats = streamingData['formats'] as List?;
      if (formats != null && formats.isNotEmpty) {
        // Sort by quality and get the best one
        formats.sort((a, b) {
          final qualityA = a['quality'] ?? '';
          final qualityB = b['quality'] ?? '';
          
          // Prefer higher quality
          final qualityOrder = ['small', 'medium', 'large', 'hd720', 'hd1080'];
          final indexA = qualityOrder.indexOf(qualityA);
          final indexB = qualityOrder.indexOf(qualityB);
          
          return indexB.compareTo(indexA); // Reverse order (higher quality first)
        });
        
        return formats.first['url'];
      }

      // If no muxed streams, try adaptive formats (video-only)
      final adaptiveFormats = streamingData['adaptiveFormats'] as List?;
      if (adaptiveFormats != null && adaptiveFormats.isNotEmpty) {
        // Filter for video streams and get the best quality
        final videoFormats = adaptiveFormats.where((format) {
          final mimeType = format['mimeType'] ?? '';
          return mimeType.startsWith('video/');
        }).toList();
        
        if (videoFormats.isNotEmpty) {
          // Sort by quality
          videoFormats.sort((a, b) {
            final qualityA = a['quality'] ?? '';
            final qualityB = b['quality'] ?? '';
            
            final qualityOrder = ['small', 'medium', 'large', 'hd720', 'hd1080'];
            final indexA = qualityOrder.indexOf(qualityA);
            final indexB = qualityOrder.indexOf(qualityB);
            
            return indexB.compareTo(indexA);
          });
          
          return videoFormats.first['url'];
        }
      }

      print('No suitable stream formats found');
      return null;
      
    } catch (e) {
      print('Error extracting stream URL: $e');
      return null;
    }
  }

  void dispose() {
    _httpClient.close();
  }
}