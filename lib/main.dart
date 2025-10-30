import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Catalogo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo usando assets registrados en pubspec.yaml
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/icons/Icon-512.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Capa con oscurecimiento sutil para mejorar legibilidad
          Container(color: Colors.black.withOpacity(0.35)),
          // Contenido centrado: mensaje de bienvenida y nombre de la app
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('¡Bienvenido!', style: AppTextStyles.welcome),
                SizedBox(height: 12),
                Text('Namer App', style: AppTextStyles.appName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Se retiró el listado de tarjetas para simplificar la pantalla de inicio