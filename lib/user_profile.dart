// user_profile.dart
import 'event.dart';

class UserProfile {
  final String id;
  final String name;
  final String imageUrl;
  final String role;
  final int eventsPlanned;
  final int eventsAttended;
  final int followers;
  final List<Event> myEvents;
  final List<String> savedThemes;
  final List<String> wishlist;

  UserProfile({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.eventsPlanned,
    required this.eventsAttended,
    required this.followers,
    required this.myEvents,
    required this.savedThemes,
    required this.wishlist,
  });
}
