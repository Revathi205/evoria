class Event {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String date;
  final String time;
  final String location;
  final String category;
  final double? price;
  final int? attendees;
  final List<String> tags;
  final List<String> vendors;
  // New fields for event creation
  final String theme;
  final String colorHex;
  final bool enableRSVP;
  final bool enableBudgetTracker;
  final bool enableTodoChecklist;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Additional fields that were missing
  final String name;
  final String type;
  final DateTime dateTime;
  final String notes;
  final int color;

  Event({
    required this.id,
    required this.title,
    String? description,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.location,
    String? category,
    this.price,
    this.attendees,
    this.tags = const [],
    this.vendors = const [],
    this.theme = 'Classic',
    this.colorHex = '#F8E71C',
    this.enableRSVP = false,
    this.enableBudgetTracker = false,
    this.enableTodoChecklist = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Additional required fields
    String? name,
    String? type,
    DateTime? dateTime,
    String? notes,
    int? color,
  }) : 
    this.description = description ?? '',
    this.category = category ?? 'General',
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now(),
    this.name = name ?? title,
    this.type = type ?? category ?? 'General',
    this.dateTime = dateTime ?? DateTime.now(),
    this.notes = notes ?? description ?? '',
    this.color = color ?? 0xFFF8E71C;

  // Convert Event to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
      'time': time,
      'location': location,
      'category': category,
      'type': type,
      'price': price,
      'attendees': attendees,
      'tags': tags,
      'vendors': vendors,
      'theme': theme,
      'colorHex': colorHex,
      'color': color,
      'enableRSVP': enableRSVP,
      'enableBudgetTracker': enableBudgetTracker,
      'enableTodoChecklist': enableTodoChecklist,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
    };
  }

  // Create Event from Firestore document
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      name: map['name'] ?? map['title'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      category: map['category'],
      type: map['type'] ?? map['category'] ?? 'General',
      price: map['price']?.toDouble(),
      attendees: map['attendees']?.toInt(),
      tags: List<String>.from(map['tags'] ?? []),
      vendors: List<String>.from(map['vendors'] ?? []),
      theme: map['theme'] ?? 'Classic',
      colorHex: map['colorHex'] ?? '#F8E71C',
      color: map['color'] ?? 0xFFF8E71C,
      enableRSVP: map['enableRSVP'] ?? false,
      enableBudgetTracker: map['enableBudgetTracker'] ?? false,
      enableTodoChecklist: map['enableTodoChecklist'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : DateTime.now(),
      dateTime: map['dateTime'] != null 
          ? DateTime.parse(map['dateTime']) 
          : DateTime.now(),
      notes: map['notes'] ?? map['description'] ?? '',
    );
  }

  // Helper method to copy event with new values
  Event copyWith({
    String? id,
    String? title,
    String? name,
    String? description,
    String? imageUrl,
    String? date,
    String? time,
    String? location,
    String? category,
    String? type,
    double? price,
    int? attendees,
    List<String>? tags,
    List<String>? vendors,
    String? theme,
    String? colorHex,
    int? color,
    bool? enableRSVP,
    bool? enableBudgetTracker,
    bool? enableTodoChecklist,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dateTime,
    String? notes,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      category: category ?? this.category,
      type: type ?? this.type,
      price: price ?? this.price,
      attendees: attendees ?? this.attendees,
      tags: tags ?? this.tags,
      vendors: vendors ?? this.vendors,
      theme: theme ?? this.theme,
      colorHex: colorHex ?? this.colorHex,
      color: color ?? this.color,
      enableRSVP: enableRSVP ?? this.enableRSVP,
      enableBudgetTracker: enableBudgetTracker ?? this.enableBudgetTracker,
      enableTodoChecklist: enableTodoChecklist ?? this.enableTodoChecklist,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }
}