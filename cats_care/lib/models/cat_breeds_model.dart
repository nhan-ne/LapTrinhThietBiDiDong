class CatBreed {
  final String name;
  final String imageUrl;
  final String? weight;
  final String? height;
  final String? lifespan;
  final String? fur;
  final Map<String, dynamic>? appearance;
  final Map<String, dynamic>? grooming;
  final Map<String, dynamic>? health;
  final Map<String, dynamic>? personality;

  CatBreed({
    required this.name,
    required this.imageUrl,
    this.weight,
    this.height,
    this.lifespan,
    this.fur,
    this.appearance,
    this.grooming,
    this.health,
    this.personality,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      name: json['name'],
      imageUrl: json['imageUrl'],
      weight: json['weight'],
      height: json['height'],
      lifespan: json['lifespan'],
      fur: json['fur'],
      appearance: json['appearance'],
      grooming: json['grooming'],
      health: json['health'],
      personality: json['personality'],
    );
  }
}