import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoria_app/event.dart';
import 'package:evoria_app/vendor.dart'; // Import the actual vendor file

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference for events
  CollectionReference get _eventsCollection => 
      _firestore.collection('events');
  
  // Collection reference for vendors
  CollectionReference get _vendorsCollection => 
      _firestore.collection('vendors');

  // Add vendor to event
  Future<bool> addVendorToEvent(String eventId, String vendorId) async {
    try {
      // Get the event document
      DocumentSnapshot eventDoc = await _eventsCollection.doc(eventId).get();
      
      if (!eventDoc.exists) {
        throw Exception('Event not found');
      }
      
      // Get current event data
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      List<String> currentVendors = List<String>.from(eventData['vendors'] ?? []);
      
      // Check if vendor is already added
      if (currentVendors.contains(vendorId)) {
        return false; // Vendor already added
      }
      
      // Add vendor to the list
      currentVendors.add(vendorId);
      
      // Update the event document
      await _eventsCollection.doc(eventId).update({
        'vendors': currentVendors,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      return true; // Successfully added
    } catch (e) {
      print('Error adding vendor to event: $e');
      return false;
    }
  }
  
  // Remove vendor from event
  Future<bool> removeVendorFromEvent(String eventId, String vendorId) async {
    try {
      // Get the event document
      DocumentSnapshot eventDoc = await _eventsCollection.doc(eventId).get();
      
      if (!eventDoc.exists) {
        throw Exception('Event not found');
      }
      
      // Get current event data
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      List<String> currentVendors = List<String>.from(eventData['vendors'] ?? []);
      
      // Remove vendor from the list
      currentVendors.remove(vendorId);
      
      // Update the event document
      await _eventsCollection.doc(eventId).update({
        'vendors': currentVendors,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      return true; // Successfully removed
    } catch (e) {
      print('Error removing vendor from event: $e');
      return false;
    }
  }
  
  // Get vendors for a specific event
  Future<List<Vendor>> getEventVendors(String eventId) async {
    try {
      // Get the event document
      DocumentSnapshot eventDoc = await _eventsCollection.doc(eventId).get();
      
      if (!eventDoc.exists) {
        return [];
      }
      
      // Get vendor IDs from event
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      List<String> vendorIds = List<String>.from(eventData['vendors'] ?? []);
      
      if (vendorIds.isEmpty) {
        return [];
      }
      
      // Get vendor documents
      List<Vendor> vendors = [];
      for (String vendorId in vendorIds) {
        DocumentSnapshot vendorDoc = await _vendorsCollection.doc(vendorId).get();
        if (vendorDoc.exists) {
          Map<String, dynamic> vendorData = vendorDoc.data() as Map<String, dynamic>;
          vendors.add(Vendor.fromMap(vendorData));
        }
      }
      
      return vendors;
    } catch (e) {
      print('Error getting event vendors: $e');
      return [];
    }
  }
  
  // Update event
  Future<bool> updateEvent(Event event) async {
    try {
      await _eventsCollection.doc(event.id).update(event.toMap());
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }
  
  // Get event by ID
  Future<Event?> getEvent(String eventId) async {
    try {
      DocumentSnapshot doc = await _eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting event: $e');
      return null;
    }
  }
  
  // Stream of event changes (for real-time updates)
  Stream<Event?> streamEvent(String eventId) {
    return _eventsCollection.doc(eventId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Event.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
  
  // Stream of event vendors (for real-time updates)
  Stream<List<Vendor>> streamEventVendors(String eventId) {
    return streamEvent(eventId).asyncMap((event) async {
      if (event != null && event.vendors != null) {
        return await getEventVendors(eventId);
      }
      return <Vendor>[];
    });
  }
}