// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.audioUrl,
  });

  final double? width;
  final double? height;
  final String audioUrl;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.audioUrl);
      setState(() {
        _duration = _player.duration ?? Duration.zero;
        _isLoading = false;
      });
      _player.positionStream.listen((pos) {
        if (mounted) setState(() => _position = pos);
      });
      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state.playing);
          if (state.processingState == ProcessingState.completed) {
            _player.seek(Duration.zero);
            _player.pause();
          }
        }
      });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text('Could not load audio', style: GoogleFonts.inter(color: Colors.red.shade400, fontSize: 13)),
      );
    }

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(color: Color(0xFFD4A574))),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _isPlaying ? _player.pause() : _player.play(),
                child: Container(
                  width: 48, height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4A574),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: const Color(0xFFD4A574),
                        inactiveTrackColor: const Color(0xFFE8DDD1),
                        thumbColor: const Color(0xFFD4A574),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: _duration.inMilliseconds > 0
                            ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
                            : 0.0,
                        onChanged: (v) => _player.seek(Duration(milliseconds: (v * _duration.inMilliseconds).toInt())),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fmt(_position), style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7C7C7C))),
                        Text(_fmt(_duration), style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7C7C7C))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
