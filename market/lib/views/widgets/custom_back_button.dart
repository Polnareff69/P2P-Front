import 'package:flutter/material.dart';

/// Un botón de volver extremadamente simple (solo icono)
class BackIcon extends StatelessWidget {
  /// Color del icono
  final Color iconColor;

  /// Tamaño del icono
  final double size;

  /// Determina si se muestra la sombra
  final bool showShadow;

  /// Color de la sombra
  final Color shadowColor;

  /// Opacidad de la sombra
  final double shadowOpacity;

  /// Acción a realizar al presionar el icono
  final VoidCallback? onPressed;

  const BackIcon({
    super.key,
    this.iconColor = Colors.deepPurpleAccent,
    this.size = 33.0,
    this.showShadow = true,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.3,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Icon(
        Icons.arrow_back_ios,
        color: iconColor,
        size: size,
        shadows:
            showShadow
                ? [
                  Shadow(
                    color: shadowColor.withOpacity(
                      shadowOpacity,
                    ),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
                : null,
      ),
    );
  }
}

/// Versión con animación sutil al presionar
class AnimatedSimpleBackIcon extends StatefulWidget {
  /// Color del icono
  final Color iconColor;

  /// Tamaño del icono
  final double size;

  /// Determina si se muestra la sombra
  final bool showShadow;

  /// Color de la sombra
  final Color shadowColor;

  /// Opacidad de la sombra
  final double shadowOpacity;

  /// Acción a realizar al presionar el icono
  final VoidCallback? onPressed;

  const AnimatedSimpleBackIcon({
    super.key,
    this.iconColor = Colors.deepPurpleAccent,
    this.size = 30.0,
    this.showShadow = true,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.3,
    this.onPressed,
  });

  @override
  _AnimatedSimpleBackIconState createState() =>
      _AnimatedSimpleBackIconState();
}

class _AnimatedSimpleBackIconState
    extends State<AnimatedSimpleBackIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: BackIcon(
              iconColor: widget.iconColor,
              size: widget.size,
              showShadow: widget.showShadow,
              shadowColor: widget.shadowColor,
              shadowOpacity: widget.shadowOpacity,
              onPressed: null,
            ),
          );
        },
      ),
    );
  }
}

// Ejemplos de uso:
// SimpleBackIcon()  // Con configuración por defecto
// SimpleBackIcon(iconColor: Colors.white, size: 36, showShadow: false)  // Sin sombra, blanco y más grande
// AnimatedSimpleBackIcon(iconColor: Colors.black, shadowColor: Colors.purple)  // Animado con sombra púrpura
