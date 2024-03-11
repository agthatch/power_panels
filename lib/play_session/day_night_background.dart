import 'package:flutter/material.dart';

class DayNightBackground extends StatefulWidget {
  final bool isDay;
  final String imageNight = 'assets/images/CityScape-night.png';
  final String imageDay = 'assets/images/CityScape-day.png';
  final String sunImage = 'assets/images/sun.png';
  final String moonImage = 'assets/images/moon.png';

  const DayNightBackground({super.key, required this.isDay});

  @override
  State<DayNightBackground> createState() => _DayNightBackgroundState();
}

class _DayNightBackgroundState extends State<DayNightBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _animationValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Color.fromRGBO(1, 39, 140, 1.0),
      end: Color.fromRGBO(0, 198, 252, 1.0),
    ).animate(_controller);

    _animationValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    // Start animation when isDay changes
    if (!widget.isDay) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant DayNightBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDay != widget.isDay) {
      if (!widget.isDay) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: _backgroundColorAnimation.value,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Sun animation
              Positioned(
                top: 50 + screenHeight - (_animationValue.value) * screenHeight,
                left: 50,
                child: Image.asset(
                  widget.sunImage,
                  width: 100,
                  height: 100,
                ),
              ),
              // Moon animation
              Positioned(
                top: 50 + (_animationValue.value) * screenHeight,
                right: 50,
                child: Image.asset(
                  widget.moonImage,
                  width: 100,
                  height: 100,
                ),
              ),
              // Image for day/night
              Positioned(
                bottom: 0,
                child: Image.asset(
                  widget.imageDay,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Opacity(
                    opacity: 1.0 - _animationValue.value,
                    child: Image.asset(
                      widget.imageNight,
                      fit: BoxFit.cover,
                    )),
              ),
              // Other widgets can go here
            ],
          ),
        );
      },
    );
  }
}
