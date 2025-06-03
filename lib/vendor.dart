class Vendor {
  final String id;
  final String name;
  final String category;
  final String location;
  final String description;
  final double rating;
  final String imageUrl;
  final List<String> images;
  final List<String> tags;
  final String? contact;
  final String? email;
  final String? priceRange; // Add this line
  final bool isFeatured; // <-- Add this

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.images,
    required this.tags,
    this.contact,
    this.email,
    this.priceRange,
    this.isFeatured = false, // <-- Add this
  });

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      contact: map['contact'],
      email: map['email'],
      priceRange: map['priceRange'],
      isFeatured: map['isFeatured'] ?? false, // <-- Add this
    );
  }
}
