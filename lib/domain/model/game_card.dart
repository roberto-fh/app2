class GameCard {
  const GameCard({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is GameCard && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
