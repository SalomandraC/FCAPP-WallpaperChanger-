import 'package:fcap/main.dart';
import 'package:fcap/src/utilities/scheme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          Text("Choose color theme"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    themeProvider.setTheme(AppTheme.red);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(width: 10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    themeProvider.setTheme(AppTheme.blue);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    themeProvider.setTheme(AppTheme.green);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Expanded(
            child: Center(
              child: EyeWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class EyeWidget extends StatefulWidget {
  @override
  _EyeWidgetState createState() => _EyeWidgetState();
}

class _EyeWidgetState extends State<EyeWidget> {
  Offset _cursorPos = Offset(110, 50);
  bool EyeForm = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        MouseRegion(
          onHover: (details) {
            setState(() {
              _cursorPos = details.localPosition;
            });
          },
          onEnter: (details) {
            setState(() {
              EyeForm = false;
            });
          },
          onExit: (details) {
            setState(() {
              _cursorPos = Offset(110, 50);
              EyeForm = true;
            });
          },
          child: ClipPath(
            clipper: EyeClipper(),
            child: Container(
              width: 230,
              height: 100,
              color: colorScheme.inversePrimary,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 100),
                    left: _calculatePupilPosition(_cursorPos).dx - 37,
                    top: _calculatePupilPosition(_cursorPos).dy - 37,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary,
                          ),
                          child: Center(
                            child: EyeForm
                                ? Container(
                                    width: 7,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 20,
          child: CustomPaint(
            size: Size(190, 20),
            painter: EyebrowPainter(),
          ),
        ),
      ],
    );
  }

  Offset _calculatePupilPosition(Offset cursorPos) {
    final eyeCenter = Offset(140, 40);
    final delta = cursorPos - eyeCenter;
    final distance = delta.distance;

    final maxDist = 70;
    final scaledDelta = distance > maxDist
        ? Offset(
            delta.dx * maxDist / distance,
            delta.dy * maxDist / distance,
          )
        : delta;

    return Offset(
      eyeCenter.dx + scaledDelta.dx - 15,
      eyeCenter.dy + scaledDelta.dy - 15,
    );
  }
}

class EyeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, height * 0.6);
    path.quadraticBezierTo(
      width * 0.25,
      0,
      width * 0.5,
      0,
    );
    path.quadraticBezierTo(
      width * 0.75,
      0,
      width,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height,
      width * 0.5,
      height,
    );
    path.quadraticBezierTo(
      width * 0.25,
      height,
      0,
      height * 0.7,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class EyebrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [
        Colors.brown.withOpacity(1),
        Colors.black.withOpacity(1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
    );

    final path = Path();
    path.moveTo(0, size.height * 1.7);
    path.quadraticBezierTo(
      size.width * 0.1,
      0,
      size.width * 0.5,
      -10,
    );
    path.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.0001,
      size.width,
      size.height,
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
