import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final String? venue; // Add if needed
  final int? expectedGuests; // Add if needed
  final double? budget; // Add if needed
  final DateTime? eventDate; // Add if needed
  final TimeOfDay? eventTime; // Add if needed
  final String title;
  final String description;
  final String time;
  final String imageUrl;
  final String date;
  final String dateTime; // Added to match stored data
  final String location;
  final String theme;
  final String? notes; // Added to match stored data
  final String category; // Added to match stored data
  final String type; // Added to match stored data
  final int? color; // Added to match stored data (color as number)
  final String? colorHex; // Added to match stored data
  final double? price; // Added to match stored data
  final List<String>? tags; // Added to match stored data
  final List<String>? attendees; // Added to match stored data
  final List<String>? vendors; // Added to match stored data
  final bool enableRSVP;
  final bool enableBudgetTracker;
  final bool enableTodoChecklist;
  final DateTime createdAt;
  final DateTime? updatedAt; // Added to match stored data

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
    required this.time,
    required this.imageUrl,
    required this.date,
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
  }) : dateTime = dateTime ?? date,
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
      'date': date,
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
      time: map['time'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: map['date'] ?? '',
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
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'])
          : null,
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
    String? date,
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
    );
  }

  // Utility methods
  DateTime get eventDateTime {
    try {
      return DateTime.parse(dateTime);
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
    final date = eventDateTime;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedDateTime {
    final date = eventDateTime;
    return '${date.day}/${date.month}/${date.year} at ${time}';
  }

  int get attendeeCount => attendees?.length ?? 0;
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
    return 'Event{id: $id, title: $title, date: $date, location: $location}';
  }
}