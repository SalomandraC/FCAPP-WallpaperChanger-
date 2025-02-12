import 'package:fcap/src/store/colors_scheme_info.dart';
import 'package:fcap/src/store/folder_info.dart';
import 'package:fcap/src/store/image_info.dart';
import 'package:fcap/src/utilities/list_state.dart';
import 'package:fcap/src/utilities/scheme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'src/utilities/navigation_logic.dart';
import 'src/utilities/page_state.dart';
import 'src/utilities/current_img.dart';
import 'dart:ui';
import 'src/components/parser.dart';
import 'src/components/parser_folder.dart';
import 'src/utilities/animated_list_state.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

enum AppTheme { blue, green, red }

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(360, 500),
    backgroundColor: Colors.transparent,
    alwaysOnTop: true,
    skipTaskbar: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setOpacity(0.85);
  });

  const String folderPath = 'assets/fons';
  const String animatedFolderPath = 'assets/fonsAnimated';
  final List<MyImageInfo> images = parseImagesFromFolder(folderPath);
  final List<MyFolderInfo> animated_folder =
      parseFoldersFromDirectory(animatedFolderPath);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentImg()),
        ChangeNotifierProvider(create: (context) => PageState()),
        ChangeNotifierProvider(
          create: (context) => MyImageProvider()..setImages(images),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              MyFolderImageProvider()..setAnimatedList(animated_folder),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Fone Changer APP',
      theme: appThemes[themeProvider.currentTheme],
      home: CurrentPage(),
    );
  }
}
