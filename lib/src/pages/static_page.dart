import 'package:fcap/src/store/image_info.dart';
import 'package:fcap/src/utilities/page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/list_state.dart';
import '../utilities/current_img.dart';
import '../plugins/wallpaper_manager.dart';

class StaticPage extends StatelessWidget {
  final WallpaperService _wallpaperService = WallpaperService();
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<MyImageProvider>(context);
    final pageState = Provider.of<PageState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final images = imageProvider.images;

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
                  color: colorScheme.secondaryContainer,
                  child: IconButton(
                    icon: Icon(Icons.autorenew,
                        color: colorScheme.onSecondaryContainer),
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
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
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
  final MyImageInfo image;
  final WallpaperService wallpaperService;

  HoverableRow({required this.image, required this.wallpaperService});

  @override
  _HoverableRowState createState() => _HoverableRowState();
}

class _HoverableRowState extends State<HoverableRow> {
  bool _isHovered = false;
  bool _isHoveredImg = false;
  @override
  Widget build(BuildContext context) {
    final curImg = Provider.of<CurrentImg>(context);
    final pageState = Provider.of<PageState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? colorScheme.inversePrimary : Colors.transparent,
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
                      await widget.wallpaperService
                          .copyAssets(widget.image.path.split('/').last);
                      await widget.wallpaperService
                          .setWallpaper(widget.image.path.split('/').last);
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
                      child: Image.asset(
                        widget.image.path,
                        width: 170,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.image.name.length > 4
                        ? widget.image.name
                            .substring(0, widget.image.name.length - 4)
                        : widget.image.name,
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
                      pageState.updateSelectedPage(1111);
                      curImg.updateSelectIMG(widget.image.path);
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
