import 'package:fcap/src/store/colors_scheme_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../pages/fone_page_start.dart';
import '../pages/music_page.dart';
import '../pages/home.dart';
import '../plugins/wallpaper_manager.dart';
import '../pages/static_page.dart';
import '../pages/r_static_page.dart';
import '../pages/animated_page.dart';
import '../pages/r_animated_page.dart';
import '../pages/static_full.dart';
import 'page_state.dart';
import 'dart:ui';

class CurrentPage extends StatefulWidget {
  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  bool isFonsActive = false;
  bool isMusicActive = false;
  bool isMainAreaVisible = true;
  bool animationActive = false;
  final WallpaperService _wallpaperService = WallpaperService();

  void _changeWindowSize(double width, double height) async {
    final currentSize = await windowManager.getSize();
    final targetSize = Size(width, height);

    const duration = Duration(milliseconds: 200);
    const steps = 15;

    animationActive = true;

    for (int i = 0; i <= steps; i++) {
      final newWidth = currentSize.width +
          (targetSize.width - currentSize.width) * (i / steps);
      final newHeight = currentSize.height +
          (targetSize.height - currentSize.height) * (i / steps);
      await windowManager.setSize(Size(newWidth, newHeight));
      await Future.delayed(duration ~/ steps);
    }

    animationActive = false;
  }

  void _toggleMainAreaVisibility() async {
    final currentSize = await windowManager.getSize();
    final pageState = Provider.of<PageState>(context, listen: false);
    final newHeight = isMainAreaVisible
        ? 110
        : (pageState.selectedPage == 2 || pageState.selectedPage == 0)
            ? 500
            : 600;
    _changeWindowSize(currentSize.width.toDouble(), newHeight.toDouble());
    if (isMainAreaVisible == true) {
      isMainAreaVisible = !isMainAreaVisible;
    } else {
      Future.delayed(Duration(milliseconds: 320), () {
        isMainAreaVisible = !isMainAreaVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<CustomThemeExtension>();
    final pageState = Provider.of<PageState>(context);
    Widget page;
    switch (pageState.selectedPage) {
      case 0:
        _changeWindowSize(360, 500);
        page = MyHomePage();
        break;
      case 2:
        _changeWindowSize(360, 500);
        page = MusicPage();
        break;
      case 1:
        _changeWindowSize(500, 600);
        page = FonePageStart();
        break;
      case 111:
        _changeWindowSize(500, 600);
        page = StaticPage();
        break;
      case 112:
        _changeWindowSize(500, 600);
        page = RStaticPage();
        break;
      case 121:
        _changeWindowSize(500, 600);
        page = AnimatedPage();
        break;
      case 122:
        _changeWindowSize(500, 600);
        page = RAnimatedPage();
        break;
      case 1111:
        _changeWindowSize(500, 600);
        page = StaticFull();
        break;
      default:
        throw UnimplementedError('no widget for ${pageState.selectedPage}');
    }

    var mainArea = ColoredBox(
      color: customColors?.myCustomColor ?? colorScheme.surface,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if ((constraints.maxWidth < 340 || constraints.maxHeight < 450) &&
              isMainAreaVisible == true &&
              animationActive == false) {
            return Image.asset(
              'assets/error.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          } else {
            return Column(
              children: [
                SafeArea(
                  child: Container(
                    color: customColors?.myCustomColor ?? colorScheme.surface,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (animationActive == false &&
                                  isMainAreaVisible == true) {
                                pageState.updateSelectedPage(1);
                                setState(() {
                                  isFonsActive = true;
                                  isMusicActive = false;
                                });
                                _wallpaperService.clearAssetsFolder();
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: pageState.selectedPage == 2
                                  ? EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10)
                                  : EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                              decoration: BoxDecoration(
                                color: isFonsActive
                                    ? colorScheme.primary
                                    : colorScheme.surface,
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'FONS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isFonsActive
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (animationActive == false) {
                                _toggleMainAreaVisibility();
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              color: colorScheme.primary,
                              child: Center(
                                child: pageState.selectedPage == 2
                                    ? Text(
                                        'M',
                                        style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'F',
                                        style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (animationActive == false &&
                                  isMainAreaVisible == true) {
                                pageState.updateSelectedPage(0);
                                setState(() {
                                  isMusicActive = true;
                                  isFonsActive = false;
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: pageState.selectedPage == 2
                                  ? EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10)
                                  : EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMusicActive
                                    ? colorScheme.primary
                                    : colorScheme.surface,
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'MUSIC',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMusicActive
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isMainAreaVisible,
                  child: Expanded(child: mainArea),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
