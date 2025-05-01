import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/main_screen/home_screen.dart';

// Una clase global para manejar las opciones de menú en toda la aplicación
class AppMenuManager {
  // Singleton para acceder desde cualquier parte de la app
  static final AppMenuManager _instance =
      AppMenuManager._internal();
  factory AppMenuManager() => _instance;
  AppMenuManager._internal();

  // Lista estática con todas las opciones del menú
  static List<MenuOption> getMenuOptions(
    BuildContext context,
  ) {
    return [
      MenuOption(
        icon: Icons.person,
        title: 'Mi Perfil',
        onTap: () {
          Navigator.of(context).pushNamed('/profile');
        },
      ),
      MenuOption(
        icon: Icons.home_rounded,
        title: 'Negocios',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
      ),
      MenuOption(
        icon: Icons.gavel_rounded,
        title: 'Subastas',
        onTap: () {
          Navigator.of(context).pushNamed('/auctions');
        },
      ),
      MenuOption(
        icon: Icons.school_rounded,
        title: 'Universidad',
        onTap: () {
          Navigator.of(context).pushNamed('/university');
        },
      ),
      MenuOption(
        icon: Icons.map_rounded,
        title: 'Mapa',
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed('/university_map');
        },
      ),
      MenuOption(
        icon: Icons.delivery_dining_rounded,
        title: 'Domicilios',
        onTap: () {
          Navigator.of(context).pushNamed('/delivery');
        },
      ),
    ];
  }
}

class MenuOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class FloatingMenuButton extends StatefulWidget {
  final List<MenuOption>? menuOptions;
  final Color? buttonColor;
  final Color? menuBackgroundColor;
  final Color? optionColor;
  final Color? textColor;
  final IconData? buttonIcon;
  final String? logoAssetPath;

  const FloatingMenuButton({
    Key? key,
    this.menuOptions,
    this.buttonColor,
    this.menuBackgroundColor,
    this.optionColor,
    this.textColor,
    this.buttonIcon,
    this.logoAssetPath,
  }) : super(key: key);

  @override
  State<FloatingMenuButton> createState() =>
      _FloatingMenuButtonState();
}

class _FloatingMenuButtonState
    extends State<FloatingMenuButton> {
  // Constantes de estilo para mantener consistencia
  final Color _defaultButtonColor = Color(
    0xFF121212,
  ).withOpacity(0.8);
  final Color _defaultMenuBackgroundColor = const Color(
    0xFF121212,
  );
  final Color _defaultOptionColor =
      Colors.deepPurpleAccent.shade700;
  final Color _defaultTextColor = Colors.white;

  void _showMenu(BuildContext context) {
    final options =
        widget.menuOptions ??
        AppMenuManager.getMenuOptions(context);
    final menuBackgroundColor =
        widget.menuBackgroundColor ??
        _defaultMenuBackgroundColor;
    final optionColor =
        widget.optionColor ?? _defaultOptionColor;
    final textColor = widget.textColor ?? _defaultTextColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: menuBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.shade700
                    .withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1,
                      ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return _buildMenuItem(
                      context,
                      option,
                      optionColor,
                      textColor,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        widget.buttonColor ?? _defaultButtonColor;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.shade700,
            blurRadius: 10,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0xFF121212),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showMenu(context),
        backgroundColor: buttonColor,
        elevation: 0,
        child:
            widget.logoAssetPath != null
                ? CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      widget.logoAssetPath!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                : Icon(Icons.menu, color: Colors.white),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    MenuOption option,
    Color optionColor,
    Color textColor,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        option.onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade500,
                  Colors.purple.shade900,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: Offset(2, 3),
                ),
              ],
            ),
            child: Icon(
              option.icon,
              color: Color(0xFF121212),
              size: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            option.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
                Shadow(
                  color: Colors.purpleAccent.withOpacity(
                    0.5,
                  ),
                  offset: Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
