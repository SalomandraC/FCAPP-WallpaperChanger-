import 'dart:math';

import 'package:flutter/material.dart';
import '../plugins/wallpaper_manager.dart';
import 'package:fcap/src/store/image_info.dart';
import 'package:provider/provider.dart';
import 'package:fcap/src/utilities/page_state.dart';
import '../utilities/list_state.dart';

class RStaticPage extends StatefulWidget {
  @override
  _RStaticPage createState() => _RStaticPage();
}

class _RStaticPage extends State<RStaticPage> {
  final WallpaperService _wallpaperService = WallpaperService();
  late TextEditingController _textController;
  bool _isHovered = false;
  bool _isHoveredNext = false;
  late MyImageInfo _selectedImage;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _selectRandomImage();
  }

  void _selectRandomImage() {
    final imageProvider = Provider.of<MyImageProvider>(context, listen: false);
    if (imageProvider.images.isNotEmpty) {
      final random = Random();
      final randomIndex = random.nextInt(imageProvider.images.length);
      setState(() {
        _selectedImage = imageProvider.images[randomIndex];
      });
      _wallpaperService.copyAssets(_selectedImage.path.split('/').last);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = Provider.of<PageState>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 15),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  width: 2.0,
                ),
              ),
              child: Image.asset(
                _selectedImage.path,
                width: screenWidth * 0.85,
                height: screenHeight * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 55.0),
                  child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _textController.text =
                                _selectedImage.name.length > 4
                                    ? _selectedImage.name.substring(
                                        0, _selectedImage.name.length - 4)
                                    : _selectedImage.name;
                          });
                        },
                        child: Text(
                          _selectedImage.name.length > 4
                              ? _selectedImage.name
                                  .substring(0, _selectedImage.name.length - 4)
                              : _selectedImage.name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(width: screenWidth * 0.09),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovered = false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _wallpaperService
                          .setWallpaper(_selectedImage.path.split('/').last);
                    },
                    child: Container(
                      width: screenWidth * 0.35,
                      height: screenHeight * 0.12,
                      color: _isHovered
                          ? colorScheme.primary.withOpacity(0.8)
                          : colorScheme.secondary,
                      child: Center(
                        child: Text(
                          'ACCEPT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.07),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHoveredNext = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveredNext = false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _selectRandomImage();
                    },
                    child: Container(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.12,
                      color: _isHoveredNext
                          ? colorScheme.primary.withOpacity(0.8)
                          : colorScheme.secondary,
                      child: Center(
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
