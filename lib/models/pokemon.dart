class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<PokemonType> types;
  final List<PokemonStat> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      imageUrl: json['sprites']?['front_default'] ?? '',
      types: (json['types'] as List<dynamic>?)
              ?.map((type) => PokemonType.fromJson(type))
              .toList() ??
          [],
      stats: (json['stats'] as List<dynamic>?)
              ?.map((stat) => PokemonStat.fromJson(stat))
              .toList() ??
          [],
    );
  }

  /// Convierte el Pokémon a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'imageUrl': imageUrl,
      'types': types.map((type) => type.toMap()).toList(),
      'stats': stats.map((stat) => stat.toMap()).toList(),
    };
  }

  /// Crea un Pokémon desde un Map de Firestore
  factory Pokemon.fromFirestore(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      types: (map['types'] as List<dynamic>?)
              ?.map((type) => PokemonType.fromMap(type))
              .toList() ??
          [],
      stats: (map['stats'] as List<dynamic>?)
              ?.map((stat) => PokemonStat.fromMap(stat))
              .toList() ??
          [],
    );
  }
}

class PokemonType {
  final int slot;
  final String name;

  PokemonType({
    required this.slot,
    required this.name,
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      slot: json['slot'] ?? 0,
      name: json['type']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slot': slot,
      'name': name,
    };
  }

  factory PokemonType.fromMap(Map<String, dynamic> map) {
    return PokemonType(
      slot: map['slot'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class PokemonStat {
  final int baseStat;
  final int effort;
  final String name;

  PokemonStat({
    required this.baseStat,
    required this.effort,
    required this.name,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      baseStat: json['base_stat'] ?? 0,
      effort: json['effort'] ?? 0,
      name: json['stat']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseStat': baseStat,
      'effort': effort,
      'name': name,
    };
  }

  factory PokemonStat.fromMap(Map<String, dynamic> map) {
    return PokemonStat(
      baseStat: map['baseStat'] ?? 0,
      effort: map['effort'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItem> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => PokemonListItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PokemonListItem {
  final String name;
  final String url;

  PokemonListItem({
    required this.name,
    required this.url,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  int get id {
    // Extraer el ID de la URL: https://pokeapi.co/api/v2/pokemon/132/
    final parts = url.split('/');
    final idString = parts[parts.length - 2];
    return int.tryParse(idString) ?? 0;
  }
}

