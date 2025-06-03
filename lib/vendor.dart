class Vendor {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double rating;
  final String description;
  final String location;
  final String? priceRange;
  final String? contact;
  final String? email;
  final List<String> tags;
  final List<String> images;
  final bool isFeatured;

  Vendor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.description,
    required this.location,
    this.priceRange,
    this.contact,
    this.email,
    required this.tags,
    required this.images,
    this.isFeatured = false,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      priceRange: json['priceRange'],
      contact: json['contact'],
      email: json['email'],
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'description': description,
      'location': location,
      'priceRange': priceRange,
      'contact': contact,
      'email': email,
      'tags': tags,
      'images': images,
      'isFeatured': isFeatured,
    };
  }

  @override
  String toString() {
    return 'Vendor(id: $id, name: $name, category: $category, rating: $rating, location: $location, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vendor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Copy with method for creating modified instances
  Vendor copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? category,
    double? rating,
    String? description,
    String? location,
    String? priceRange,
    String? contact,
    String? email,
    List<String>? tags,
    List<String>? images,
    bool? isFeatured,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      location: location ?? this.location,
      priceRange: priceRange ?? this.priceRange,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}