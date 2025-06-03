import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoria_app/event.dart';
import 'vendor.dart';

class Vendor {
  final String id;
  final String name;
  final String category;
  final bool isFeatured;
  // Add other fields as needed

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.isFeatured,
    // Add other fields as needed
  });

  // Add the fromMap factory constructor
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      // Map other fields as needed
    );
  }
}

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference for events
  CollectionReference get _eventsCollection => 
      _firestore.collection('events');
  
  // Collection reference for vendors
  CollectionReference get _vendorsCollection => 
      _firestore.collection('vendors');

  // Get all vendors from Firestore
  Future<List<Vendor>> getAllVendors() async {
    try {
      QuerySnapshot vendorSnapshot = await _vendorsCollection.get();
      
      List<Vendor> vendors = [];
      for (QueryDocumentSnapshot doc in vendorSnapshot.docs) {
        Map<String, dynamic> vendorData = doc.data() as Map<String, dynamic>;
        // Add the document ID to the vendor data if it's not already there
        vendorData['id'] = doc.id;
        vendors.add(Vendor.fromMap(vendorData));
      }
      
      return vendors;
    } catch (e) {
      print('Error fetching all vendors: $e');
      throw Exception('Failed to load vendors: $e');
    }
  }

  // Get vendors with optional filtering
  Future<List<Vendor>> getVendorsByCategory(String category) async {
    try {
      QuerySnapshot vendorSnapshot = await _vendorsCollection
          .where('category', isEqualTo: category)
          .get();
      
      List<Vendor> vendors = [];
      for (QueryDocumentSnapshot doc in vendorSnapshot.docs) {
        Map<String, dynamic> vendorData = doc.data() as Map<String, dynamic>;
        vendorData['id'] = doc.id;
        vendors.add(Vendor.fromMap(vendorData));
      }
      
      return vendors;
    } catch (e) {
      print('Error fetching vendors by category: $e');
      return [];
    }
  }

  // Stream all vendors for real-time updates
  Stream<List<Vendor>> streamAllVendors() {
    return _vendorsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> vendorData = doc.data() as Map<String, dynamic>;
        vendorData['id'] = doc.id;
        return Vendor.fromMap(vendorData);
      }).toList();
    });
  }

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
          vendorData['id'] = vendorDoc.id; // Ensure ID is included
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
        Map<String, dynamic> eventData = doc.data() as Map<String, dynamic>;
        eventData['id'] = doc.id; // Ensure ID is included
        return Event.fromMap(eventData);
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
        Map<String, dynamic> eventData = snapshot.data() as Map<String, dynamic>;
        eventData['id'] = snapshot.id; // Ensure ID is included
        return Event.fromMap(eventData);
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