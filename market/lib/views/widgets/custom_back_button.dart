import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget personalizado para botón de volver atrás
class CustomBackButton extends StatelessWidget {
  // Parámetros personalizables
  final String? tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final EdgeInsetsGeometry padding;
  final bool showShadow;

  // Constructor con valores predeterminados
  const CustomBackButton({
    Key? key,
    this.tooltip = 'Volver',
    this.onPressed,
    this.color = Colors.deepPurpleAccent,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Función de volver atrás predeterminada si no se proporciona una personalizada
    final VoidCallback defaultOnPressed = () {
      Navigator.of(context).pop();
    };

    return Container(
      decoration: showShadow ? BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color!.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: -2,
            offset: Offset(0, 2),
          ),
        ],
      ) : null,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: Tooltip(
          message: tooltip!,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPressed ?? defaultOnPressed,
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    color: color,
                    size: size,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Volver',
                    style: GoogleFonts.nunitoSans(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: size * 0.75,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Variante con animación al pulsar
class AnimatedBackButton extends StatefulWidget {
  final String? tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const AnimatedBackButton({
    Key? key,
    this.tooltip = 'Volver',
    this.onPressed,
    this.color = Colors.deepPurpleAccent,
    this.size = 24.0,
  }) : super(key: key);

  @override
  _AnimatedBackButtonState createState() => _AnimatedBackButtonState();
}

class _AnimatedBackButtonState extends State<AnimatedBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
            child: CustomBackButton(
              tooltip: widget.tooltip,
              color: widget.color,
              size: widget.size,
              showShadow: true,
              onPressed: null, // Manejamos el onPressed en el GestureDetector
            ),
          );
        },
      ),
    );
  }
}

// Ejemplo de uso:
// CustomBackButton()  // Versión simple
// AnimatedBackButton()  // Versión con animación al pulsar