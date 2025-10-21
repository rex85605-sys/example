import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/youtube_service.dart';

class PlayerScreen extends StatefulWidget {
  final Video video;

  const PlayerScreen({super.key, required this.video});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final YouTubeService _youtubeService = YouTubeService();
  String? _streamUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStreamUrl();
  }

  @override
  void dispose() {
    _youtubeService.dispose();
    super.dispose();
  }

  Future<void> _loadStreamUrl() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final url = await _youtubeService.getStreamUrl(widget.video.id);
      
      setState(() {
        _streamUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load video: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Video player area
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: _buildPlayerArea(),
          ),
          // Video information
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (widget.video.channelName != null)
                    Text(
                      widget.video.channelName!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.video.viewCount != null) ...[
                        Text(
                          widget.video.viewCount!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                      if (widget.video.viewCount != null && widget.video.duration != null) ...[
                        Text(
                          ' • ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                      if (widget.video.duration != null) ...[
                        Text(
                          widget.video.duration!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        Icons.thumb_up_outlined,
                        'Like',
                        () {},
                      ),
                      _buildActionButton(
                        Icons.thumb_down_outlined,
                        'Dislike',
                        () {},
                      ),
                      _buildActionButton(
                        Icons.share_outlined,
                        'Share',
                        () {},
                      ),
                      _buildActionButton(
                        Icons.download_outlined,
                        'Download',
                        () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerArea() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load video',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStreamUrl,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_streamUrl == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library_outlined,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Video unavailable',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This video cannot be played',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      );
    }

    // In a real app, you would use a video player widget here
    // For now, we'll show a placeholder with the stream URL info
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.play_circle_outline,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Video Ready to Play',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stream URL obtained successfully',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // In a real app, this would start video playback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Stream URL: ${_streamUrl!.substring(0, 50)}...'),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}