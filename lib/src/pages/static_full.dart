import 'package:fcap/src/store/colors_scheme_info.dart';
import 'package:fcap/src/utilities/list_state.dart';
import '../utilities/current_img.dart';
import 'package:fcap/src/utilities/page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/image_info.dart';
import '../plugins/wallpaper_manager.dart';

class StaticFull extends StatefulWidget {
  @override
  _StaticFullState createState() => _StaticFullState();
}

class _StaticFullState extends State<StaticFull> {
  late TextEditingController _textController;
  bool _isEditing = false;
  bool _isHovered = false;
  final WallpaperService _wallpaperService = WallpaperService();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final imageProvider = Provider.of<MyImageProvider>(context, listen: false);
    final curImg = Provider.of<CurrentImg>(context, listen: false);
    final image = imageProvider.images.firstWhere(
      (img) => img.path == curImg.selectedIMG,
      orElse: () => MyImageInfo('Error', 'assets/error.jpg'),
    );
    _wallpaperService.copyAssets(image.path.split('/').last);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curImg = Provider.of<CurrentImg>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pageState = Provider.of<PageState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final customTheme =
        Theme.of(context).extension<CustomThemeExtension>()?.myCustomColor ??
            colorScheme.primary;

    return Scaffold(
      body: Consumer<MyImageProvider>(
        builder: (context, imageProvider, child) {
          var image = imageProvider.images.firstWhere(
            (img) => img.path == curImg.selectedIMG,
            orElse: () => MyImageInfo('Error', 'assets/error.jpg'),
          );

          return Column(
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
                    image.path,
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
                        offset: Offset(50, 0),
                        child: Center(
                          child: _isEditing
                              ? TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: 'Input new name',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditing = true;
                                      _textController.text =
                                          image.name.length > 4
                                              ? image.name.substring(
                                                  0, image.name.length - 4)
                                              : image.name;
                                    });
                                  },
                                  child: Text(
                                    image.name.length > 4
                                        ? image.name
                                            .substring(0, image.name.length - 4)
                                        : image.name,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: screenWidth * 0.06,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primary,
                    child: IconButton(
                      icon: Icon(Icons.add_task_outlined,
                          color: colorScheme.onPrimary),
                      onPressed: () {
                        if (_isEditing) {
                          final newName = _textController.text;
                          if (newName.isNotEmpty) {
                            curImg.updateSelectIMG(newName);
                            final index = imageProvider.images.indexOf(image);
                            imageProvider.changeName(
                                imageProvider.images, index, newName);
                            setState(() {
                              _isEditing = false;
                            });
                            _wallpaperService.clearAssetsFolder();
                            pageState.updateSelectedPage(111);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 55.0),
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          pageState.updateSelectedPage(111);
                        },
                        child: Image.asset(
                          'assets/back_step.png',
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.15),
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
                              .setWallpaper(image.path.split('/').last);
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
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
