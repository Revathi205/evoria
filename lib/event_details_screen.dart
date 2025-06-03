// event_details_screen.dart
import 'package:flutter/material.dart';
import 'event.dart';
import 'mock_data.dart';

class EventDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get event data from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    Event? event;

    if (args is Event) {
      event = args;
    } else if (args is Map<String, dynamic>) {
      if (args.containsKey('eventData')) {
        event = args['eventData'] as Event;
      } else if (args.containsKey('eventId')) {
        final String eventId = args['eventId'];
        event = MockData.sampleEvents.firstWhere(
          (e) => e.id == eventId,
          orElse: () => MockData.sampleEvents.first,
        );
      }
    } else {
      event = MockData.sampleEvents.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event!.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            Hero(
              tag: 'event-${event.id}',
              child: Image.asset(
                event.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            
            // Event details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date, time, and category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            color: Colors.pink[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_today, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(event.date),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  
                  // Event title
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  
                  // Event location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.pink),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  
                  // Event time
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.pink),
                      const SizedBox(width: 8.0),
                      Text(
                        event.time,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  
                  // Price 
                  if (event.price != null && event.price! > 0)
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8.0),
                        Text(
                          '\$${event.price?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16.0),
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(event.description ?? 'No description available'),
                  const SizedBox(height: 16.0),
                  
                  // Tags
                  if ((event.tags?.isNotEmpty ?? false)) ...[
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: event.tags!.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  
                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle registration
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration process initiated!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}