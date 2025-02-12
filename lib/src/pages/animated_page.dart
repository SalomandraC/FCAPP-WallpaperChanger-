import 'package:fcap/src/store/folder_info.dart';
import 'package:fcap/src/utilities/animated_list_state.dart';
import 'package:fcap/src/utilities/page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'dart:async';
import '../plugins/wallpaper_animated.dart';

class AnimatedPage extends StatelessWidget {
  final WallpaperServiceAnimated _wallpaperService = WallpaperServiceAnimated();

  @override
  Widget build(BuildContext context) {
    final imageFolderProvider = Provider.of<MyFolderImageProvider>(context);
    final pageState = Provider.of<PageState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final folder = imageFolderProvider.animatedList;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(7),
            color: colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      pageState.updateSelectedPage(1);
                    },
                    child: Image.asset('assets/back_step.png'),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: colorScheme.errorContainer,
                  child: IconButton(
                    icon:
                        Icon(Icons.delete, color: colorScheme.onErrorContainer),
                    onPressed: () {},
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: colorScheme.tertiaryContainer,
                  child: IconButton(
                    icon: Icon(Icons.autorenew,
                        color: colorScheme.onTertiaryContainer),
                    onPressed: () {},
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: Icon(Icons.add, color: colorScheme.onPrimary),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: folder.length,
              itemBuilder: (context, index) {
                final image = folder[index];
                return HoverableRow(
                    image: image, wallpaperService: _wallpaperService);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HoverableRow extends StatefulWidget {
  final MyFolderInfo image;
  final WallpaperServiceAnimated wallpaperService;

  HoverableRow({required this.image, required this.wallpaperService});

  @override
  _HoverableRowState createState() => _HoverableRowState();
}

class _HoverableRowState extends State<HoverableRow> {
  bool _isHovered = false;
  bool _isHoveredImg = false;
  List<File> _images = [];
  int _currentImageIndex = 0;
  Timer? _timer;
  bool _isWallpaperCycling = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadImages() async {
    final directory = Directory(widget.image.path);
    if (await directory.exists()) {
      final files = directory.listSync();
      setState(() {
        _images = files
            .where((file) => file is File && file.path.endsWith('.jpg'))
            .map((file) => File(file.path))
            .toList();
      });
      for (final imageFile in _images) {
        precacheImage(FileImage(imageFile), context);
      }
    }
  }

  void _startImageSlider() {
    _timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      if (!mounted) return;

      final newIndex = (_currentImageIndex + 1) % _images.length;
      if (newIndex != _currentImageIndex) {
        setState(() {
          _currentImageIndex = newIndex;
        });
      }
    });
  }

  void _stopImageSlider() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _toggleWallpaperCycle() async {
    if (_isWallpaperCycling) {
      widget.wallpaperService.stopCyclicWallpaperChange();
      setState(() {
        _isWallpaperCycling = false;
      });
    } else {
      widget.wallpaperService.startCyclicWallpaperChange(widget.image.name);
      setState(() {
        _isWallpaperCycling = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? colorScheme.surfaceVariant.withOpacity(0.5)
            : Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setState(() {
                      _isHoveredImg = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveredImg = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      await _toggleWallpaperCycle();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isHoveredImg
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: _isHoveredImg ? 5 : 0.5,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 170),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: _images.isNotEmpty
                            ? Image.file(
                                _images[_currentImageIndex],
                                width: 170,
                                height: 140,
                                fit: BoxFit.cover,
                                key: ValueKey(_currentImageIndex),
                              )
                            : const Placeholder(
                                fallbackWidth: 170,
                                fallbackHeight: 140,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.image.name,
                    style: TextStyle(
                      fontSize: 24,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: Icon(Icons.play_arrow, color: colorScheme.onPrimary),
                    onPressed: () {
                      if (_timer == null) {
                        _startImageSlider();
                      } else {
                        _stopImageSlider();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
