import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/pokemon.dart';
import 'services/pokemon_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Catálogo Pokémon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga una lista de Pokémon desde la API
  Future<void> loadPokemonList({int limit = 20, int offset = 0}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _pokemonService.getPokemonList(
        limit: limit,
        offset: offset,
      );

      // Obtener los detalles de cada Pokémon
      final List<Pokemon> pokemonDetails = [];
      for (var item in response.results) {
        try {
          final pokemon = await _pokemonService.getPokemonById(item.id);
          pokemonDetails.add(pokemon);
        } catch (e) {
          // Si falla obtener un Pokémon, continuamos con los demás
          print('Error al obtener Pokémon ${item.name}: $e');
        }
      }

      _pokemonList = pokemonDetails;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar los Pokémon: $e';
      _pokemonList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene un Pokémon específico por nombre
  Future<Pokemon?> getPokemonByName(String name) async {
    try {
      return await _pokemonService.getPokemonByName(name);
    } catch (e) {
      _errorMessage = 'Error al obtener el Pokémon: $e';
      notifyListeners();
      return null;
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar los Pokémon al iniciar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAppState>().loadPokemonList(limit: 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Catálogo Pokémon',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
          Container(color: Colors.black.withOpacity(0.5)),
          // Contenido principal
          SafeArea(
            child: Consumer<MyAppState>(
              builder: (context, appState, child) {
                if (appState.isLoading && appState.pokemonList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Cargando Pokémon...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (appState.errorMessage != null &&
                    appState.pokemonList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appState.errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              appState.loadPokemonList(limit: 20);
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (appState.pokemonList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay Pokémon disponibles',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '¡Bienvenido al Catálogo Pokémon!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: appState.pokemonList.length,
                        itemBuilder: (context, index) {
                          final pokemon = appState.pokemonList[index];
                          return _PokemonCard(pokemon: pokemon);
                        },
                      ),
                    ),
                    if (appState.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MyAppState>().loadPokemonList(limit: 20);
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Recargar Pokémon',
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Imagen del Pokémon
            if (pokemon.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pokemon.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 12),
            // Información del Pokémon
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${pokemon.id} - ${pokemon.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Altura: ${pokemon.height / 10}m | Peso: ${pokemon.weight / 10}kg',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: pokemon.types.map((type) {
                      return Chip(
                        label: Text(
                          type.name.toUpperCase(),
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: _getTypeColor(type.name),
                        padding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    final colors = {
      'normal': Colors.grey[300]!,
      'fire': Colors.red[300]!,
      'water': Colors.blue[300]!,
      'electric': Colors.yellow[300]!,
      'grass': Colors.green[300]!,
      'ice': Colors.cyan[300]!,
      'fighting': Colors.orange[700]!,
      'poison': Colors.purple[300]!,
      'ground': Colors.brown[300]!,
      'flying': Colors.indigo[300]!,
      'psychic': Colors.pink[300]!,
      'bug': Colors.lightGreen[300]!,
      'rock': Colors.brown[400]!,
      'ghost': Colors.purple[400]!,
      'dragon': Colors.deepPurple[300]!,
      'dark': Colors.grey[700]!,
      'steel': Colors.grey[400]!,
      'fairy': Colors.pink[200]!,
    };
    return colors[type] ?? Colors.grey[300]!;
  }
}