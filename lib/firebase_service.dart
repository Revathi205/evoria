import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _eventsCollection = 'events';

  // Create/Save Event
  static Future<String?> createEvent(Event event) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_eventsCollection)
          .add(event.toMap());
      
      // Update the event with the generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  // Get all events
  static Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_eventsCollection)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

  // Get single event by ID
  static Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .get();
      
      if (doc.exists) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting event: $e');
      return null;
    }
  }

  // Update event
  static Future<bool> updateEvent(Event event) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(event.id)
          .update(event.toMap());
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  // Delete event
  static Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }

  // Stream of events (for real-time updates)
  static Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection(_eventsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.data()))
            .toList());
  }

  // Get events by user (you can add userId field to events later)
  static Future<List<Event>> getUserEvents(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_eventsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user events: $e');
      return [];
    }
  }
}