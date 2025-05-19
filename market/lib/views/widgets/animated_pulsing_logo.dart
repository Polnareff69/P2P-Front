import 'package:flutter/material.dart';

class AnimatedPulsingLogo extends StatefulWidget {
  final String logoAssetPath;
  final double size;
  final Color glowColor;
  final Duration pulseDuration;
  final double pulseScale;

  const AnimatedPulsingLogo({
    Key? key,
    required this.logoAssetPath,
    this.size = 200,
    this.glowColor = Colors.purple,
    this.pulseDuration = const Duration(seconds: 3),
    this.pulseScale = 1.1,
  }) : super(key: key);

  @override
  State<AnimatedPulsingLogo> createState() =>
      _AnimatedPulsingLogoState();
}

class _AnimatedPulsingLogoState
    extends State<AnimatedPulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar el controlador de animación
    _animationController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    )..repeat(reverse: true);

    // Configurar la animación de pulsación
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.4),
                  blurRadius: 70,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                widget.size / 2,
              ),
              child: Image.asset(
                widget.logoAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: widget.glowColor.withOpacity(
                      0.2,
                    ),
                    child: Icon(
                      Icons.image,
                      size: widget.size * 0.3,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
