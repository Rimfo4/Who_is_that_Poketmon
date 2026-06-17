class Pokemon {
  final int id;
  final String name;
  final String nameEn;
  final List<String> types;
  final String description;
  final List<String> aliases;

  const Pokemon({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.types,
    required this.description,
    this.aliases = const [],
  });
}