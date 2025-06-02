class Vendor {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double rating;
  final String description;
  final String location;
  final List<String> tags;
  final List<String> images;
  final bool isFeatured;

  Vendor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.description = '',
    this.location = '',
    this.tags = const [],
    this.images = const [],
    this.isFeatured = false,
  });
}
