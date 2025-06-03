import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final String? venue;
  final int? expectedGuests;
  final double? budget;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String title;
  final String description;
  final String? time; // Changed to nullable for consistency
  final String imageUrl;
  final DateTime date; // Changed to DateTime instead of String
  final String dateTime; // Keep for backward compatibility
  final String location;
  final String theme;
  final String? notes;
  final String category;
  final String type;
  final int? color;
  final String? colorHex;
  final double? price;
  final List<String>? tags;
  final List<String>? attendees;
  final List<String>? vendors;
  final bool enableRSVP;
  final bool enableBudgetTracker;
  final bool enableTodoChecklist;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? guestCount; // Added from the new version

  Event({
    required this.id,
    required this.name,
    this.venue,
    this.expectedGuests,
    this.budget,
    this.eventDate,
    this.eventTime,
    required this.title,
    required this.description,
    this.time,
    required this.imageUrl,
    required this.date, // Now required DateTime
    String? dateTime,
    required this.location,
    required this.theme,
    this.notes,
    String? category,
    String? type,
    this.color,
    this.colorHex,
    this.price,
    this.tags,
    this.attendees,
    this.vendors,
    required this.enableRSVP,
    required this.enableBudgetTracker,
    required this.enableTodoChecklist,
    required this.createdAt,
    this.updatedAt,
    this.guestCount,
  }) : dateTime = dateTime ?? date.toIso8601String().split('T')[0], // Generate from DateTime
       category = category ?? 'General',
       type = type ?? 'General';

  // Convert Event to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'venue': venue,
      'expectedGuests': expectedGuests,
      'budget': budget,
      'eventDate': eventDate?.toIso8601String(),
      'eventTime': eventTime != null ? '${eventTime!.hour}:${eventTime!.minute}' : null,
      'title': title,
      'description': description,
      'time': time,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(), // Convert DateTime to String for storage
      'dateTime': dateTime,
      'location': location,
      'theme': theme,
      'notes': notes,
      'category': category,
      'type': type,
      'color': color,
      'colorHex': colorHex,
      'price': price,
      'tags': tags,
      'attendees': attendees,
      'vendors': vendors,
      'enableRSVP': enableRSVP,
      'enableBudgetTracker': enableBudgetTracker,
      'enableTodoChecklist': enableTodoChecklist,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'guestCount': guestCount,
    };
  }

  // Create Event from Firestore Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      venue: map['venue'],
      expectedGuests: map['expectedGuests'],
      budget: map['budget'] != null ? double.tryParse(map['budget'].toString()) : null,
      eventDate: map['eventDate'] != null ? DateTime.parse(map['eventDate']) : null,
      eventTime: map['eventTime'] != null ? TimeOfDay(
        hour: int.parse(map['eventTime'].split(':')[0]),
        minute: int.parse(map['eventTime'].split(':')[1]),
      ) : null,
      title: map['title'] ?? map['name'] ?? '',
      description: map['description'] ?? '',
      time: map['time'],
      imageUrl: map['imageUrl'] ?? '',
      date: map['date'] is String 
          ? DateTime.parse(map['date']) 
          : map['date'] ?? DateTime.now(), // Improved date parsing
      dateTime: map['dateTime'] ?? map['date'] ?? '',
      location: map['location'] ?? '',
      theme: map['theme'] ?? 'Classic',
      notes: map['notes'],
      category: map['category'] ?? 'General',
      type: map['type'] ?? 'General',
      color: map['color'],
      colorHex: map['colorHex'],
      price: map['price']?.toDouble(),
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      attendees: map['attendees'] != null ? List<String>.from(map['attendees']) : null,
      vendors: map['vendors'] != null ? List<String>.from(map['vendors']) : null,
      enableRSVP: map['enableRSVP'] ?? false,
      enableBudgetTracker: map['enableBudgetTracker'] ?? false,
      enableTodoChecklist: map['enableTodoChecklist'] ?? false,
      createdAt: map['createdAt'] is String 
          ? DateTime.parse(map['createdAt']) 
          : map['createdAt'] ?? DateTime.now(), // Improved createdAt parsing
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] is String 
              ? DateTime.parse(map['updatedAt'])
              : map['updatedAt'])
          : null,
      guestCount: map['guestCount'],
    );
  }

  // Create a copy of the event with updated fields
  Event copyWith({
    String? id,
    String? name,
    String? venue,
    int? expectedGuests,
    double? budget,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? title,
    String? description,
    String? time,
    String? imageUrl,
    DateTime? date, // Changed to DateTime
    String? dateTime,
    String? location,
    String? theme,
    String? notes,
    String? category,
    String? type,
    int? color,
    String? colorHex,
    double? price,
    List<String>? tags,
    List<String>? attendees,
    List<String>? vendors,
    bool? enableRSVP,
    bool? enableBudgetTracker,
    bool? enableTodoChecklist,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? guestCount,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      venue: venue ?? this.venue,
      expectedGuests: expectedGuests ?? this.expectedGuests,
      budget: budget ?? this.budget,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      theme: theme ?? this.theme,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      type: type ?? this.type,
      color: color ?? this.color,
      colorHex: colorHex ?? this.colorHex,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      attendees: attendees ?? this.attendees,
      vendors: vendors ?? this.vendors,
      enableRSVP: enableRSVP ?? this.enableRSVP,
      enableBudgetTracker: enableBudgetTracker ?? this.enableBudgetTracker,
      enableTodoChecklist: enableTodoChecklist ?? this.enableTodoChecklist,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      guestCount: guestCount ?? this.guestCount,
    );
  }

  // Utility methods
  DateTime get eventDateTime {
    try {
      return date; // Use the DateTime field directly
    } catch (e) {
      return DateTime.now();
    }
  }

  bool get isPastEvent {
    return eventDateTime.isBefore(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    final eventDate = eventDateTime;
    return now.year == eventDate.year &&
           now.month == eventDate.month &&
           now.day == eventDate.day;
  }

  bool get isUpcoming {
    return eventDateTime.isAfter(DateTime.now());
  }

  String get formattedDate {
    final eventDate = eventDateTime;
    return '${eventDate.day}/${eventDate.month}/${eventDate.year}';
  }

  String get formattedDateTime {
    final eventDate = eventDateTime;
    return '${eventDate.day}/${eventDate.month}/${eventDate.year}${time != null ? ' at $time' : ''}';
  }

  int get attendeeCount => attendees?.length ?? guestCount ?? 0; // Use guestCount as fallback
  int get vendorCount => vendors?.length ?? 0;
  int get tagCount => tags?.length ?? 0;

  bool hasTag(String tag) => tags?.contains(tag) ?? false;
  bool hasAttendee(String attendeeId) => attendees?.contains(attendeeId) ?? false;
  bool hasVendor(String vendorId) => vendors?.contains(vendorId) ?? false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event{id: $id, title: $title, date: ${formattedDate}, location: $location}';
  }
}