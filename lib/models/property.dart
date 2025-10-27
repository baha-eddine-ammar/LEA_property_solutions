class Property {
  final String id;
  final String name;
  final String location;
  final int price;
  final double rating;
  final List<String> images;
  final String dates;
  final String description;
  bool isFavorite;

  Property({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.images,
    required this.dates,
    required this.description,
    this.isFavorite = false,
  });
}
