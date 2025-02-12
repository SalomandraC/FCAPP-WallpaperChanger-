import 'package:fcap/src/utilities/page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FonePageStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageState = Provider.of<PageState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              text: 'Статичные',
              onPressed: () {
                pageState.updateSelectedPage(111);
              },
              colorScheme: colorScheme,
            ),
            CustomButton(
              text: 'R Статичные',
              onPressed: () {
                pageState.updateSelectedPage(112);
              },
              colorScheme: colorScheme,
            ),
            CustomButton(
              text: 'Анимированные',
              onPressed: () {
                pageState.updateSelectedPage(121);
              },
              colorScheme: colorScheme,
            ),
            CustomButton(
              text: 'R Анимированные',
              onPressed: () {
                pageState.updateSelectedPage(122);
              },
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  CustomButton({
    required this.text,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Stack(
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: _isHovered
                    ? widget.colorScheme.primary
                    : widget.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 42,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Transform.translate(
                  offset: Offset(0, 25),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _animation.value,
                          child: Container(
                            height: 2,
                            color: widget.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
