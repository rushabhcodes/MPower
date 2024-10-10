  import 'package:flutter/material.dart';
  import 'package:just_audio/just_audio.dart';
  import 'package:just_audio_background/just_audio_background.dart';

  class MusicPlayer extends StatefulWidget {
    const MusicPlayer({super.key});

    @override
    State<MusicPlayer> createState() => _MusicPlayerState();
  }

  class _MusicPlayerState extends State<MusicPlayer> {
    late AudioPlayer _audioPlayer;
    final List<AudioSource> _playlist = [
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/calm-soul-meditation.mp3'),
        tag: MediaItem(
          id: '1',
          title: 'Calm Meditation',
          artist: 'Relaxing Music',
          artUri: Uri.parse('asset:///assets/images/calm.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/nature_sounds.mp3'),
        tag: MediaItem(
          id: '2',
          title: 'Nature Sounds',
          artist: 'Peaceful Moments',
          artUri: Uri.parse('asset:///assets/images/question-aire.jpg'),
        ),
      ),
    ];

    @override
    void initState() {
      super.initState();
      _initAudioPlayer();
    }

    Future<void> _initAudioPlayer() async {
      _audioPlayer = AudioPlayer();
      try {
        await _audioPlayer.setAudioSource(
          ConcatenatingAudioSource(children: _playlist),
          initialIndex: 0,
          initialPosition: Duration.zero,
        );
      } catch (e) {
        debugPrint("Error loading audio source: $e");
      }
    }

    @override
    void dispose() {
      _audioPlayer.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Material(  // Added Material widget wrapper
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<SequenceState?>(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                      children: [
                        Text(
                          metadata.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          metadata.artist ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder<Duration>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _audioPlayer.duration ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 32),
                      onPressed: () => _audioPlayer.seekToPrevious(),
                    ),
                    StreamBuilder<PlayerState>(
                      stream: _audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
          
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            child: const CircularProgressIndicator(),
                          );
                        } else if (playing != true) {
                          return IconButton(
                            icon: const Icon(Icons.play_circle, size: 64),
                            onPressed: _audioPlayer.play,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.pause_circle, size: 64),
                            onPressed: _audioPlayer.pause,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 32),
                      onPressed: () => _audioPlayer.seekToNext(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<LoopMode>(
                      stream: _audioPlayer.loopModeStream,
                      builder: (context, snapshot) {
                        final loopMode = snapshot.data ?? LoopMode.off;
                        const icons = {
                          LoopMode.off: Icons.repeat,
                          LoopMode.one: Icons.repeat_one,
                          LoopMode.all: Icons.repeat,
                        };
                        return IconButton(
                          icon: Icon(icons[loopMode]),
                          onPressed: () {
                            final modes = LoopMode.values;
                            final index = modes.indexOf(loopMode);
                            final newMode = modes[(index + 1) % modes.length];
                            _audioPlayer.setLoopMode(newMode);
                          },
                        );
                      },
                    ),
                    StreamBuilder<double>(
                      stream: _audioPlayer.volumeStream,
                      builder: (context, snapshot) {
                        final volume = snapshot.data ?? 1.0;
                        return Row(
                          children: [
                            IconButton(
                              icon: Icon(volume == 0
                                  ? Icons.volume_off
                                  : Icons.volume_up),
                              onPressed: () {
                                _audioPlayer.setVolume(volume == 0 ? 1.0 : 0.0);
                              },
                            ),
                            Slider(
                              value: volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: _audioPlayer.setVolume,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }
  }