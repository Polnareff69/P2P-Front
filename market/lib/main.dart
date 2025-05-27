import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market/views/authentication_screens/welcome_screen.dart';
import 'package:market/views/auction_screens/auctions_list_screen.dart';
import 'package:market/services/auth_service.dart';
import 'package:market/config/app_config.dart';
import 'package:flutter/foundation.dart'; //kDebug
import 'package:market/views/university_screens/universities_screen.dart';

void main() async {
  // 🚀 CONFIGURACIÓN INICIAL
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🎨 CONFIGURAR UI DEL SISTEMA
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // 📱 CONFIGURAR ORIENTACIONES
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // 📊 MOSTRAR CONFIGURACIÓN DEL ENTORNO
  AppConfig.printConfig();
  
  // 🔐 INICIALIZAR SERVICIO DE AUTENTICACIÓN
  await AuthService.instance.initialize();
  
  // 🔍 MOSTRAR ESTADO DE AUTENTICACIÓN (solo en debug)
  if (kDebugMode) {
    AuthService.instance.printCurrentState();
  }
  
  // 🎉 EJECUTAR LA APLICACIÓN
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 🔧 CONFIGURACIÓN BÁSICA
      debugShowCheckedModeBanner: false,
      title: 'U-Market',
      
      // 🎨 CONFIGURACIÓN DE TEMA
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // 🔤 CONFIGURACIÓN DE FONTS PARA MEJOR CONSISTENCIA
        fontFamily: 'Nunito',
        
        // 📱 CONFIGURACIÓN DE DENSIDAD VISUAL
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // 🎯 CONFIGURACIÓN DE TEMA ESPECÍFICO
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),

       // Añadir rutas nombradas
      routes: {
        '/university': (context) => UniversitiesScreen(),
        '/auctions': (context) => const AuctionsListScreen(),
        
      },
      
      // 🏠 PANTALLA INICIAL INTELIGENTE
      home: _getInitialScreen(),
      
      // 🛠️ CONFIGURACIÓN GLOBAL
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // 📏 MANTENER ESCALA FIJA DE TEXTO
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
  
  
  // 🎯 DETERMINAR PANTALLA INICIAL BASADA EN AUTENTICACIÓN
  Widget _getInitialScreen() {
    if (AuthService.instance.isLoggedIn) {
      // Usuario está logueado, redirigir según el rol
      if (AuthService.instance.isSeller) {
        // Aquí IR a VendorScreen ¡¡¡¡¡¡¡¡CAMBIAR!!!!!!!!!
        // Mientras tanto, mostramos WelcomeScreen con mensaje de debug
        if (kDebugMode) {
          print('🏪 Usuario es vendedor, debería ir a VendorScreen');
        }
        return const WelcomeScreen();
      } else {
        // Aquí IR a UserScreen ¡¡¡¡¡¡¡¡CAMBIAR!!!!!!!!!
        // Mientras tanto, mostramos WelcomeScreen con mensaje de debug
        if (kDebugMode) {
          print('👤 Usuario es comprador, debería ir a UserScreen');
        }
        return const WelcomeScreen();
      }
    }
    
    // Usuario no está logueado, mostrar pantalla de bienvenida
    if (kDebugMode) {
      print('🚪 Usuario no logueado, mostrando WelcomeScreen');
    }
    return const WelcomeScreen();
  }
}