import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/add_movie_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Películas',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => HomeScreen(),
        '/admin': (_) => AdminScreen(),
        '/addMovie': (context) => const AddMovieScreen(),
      },
    );
  }
}
