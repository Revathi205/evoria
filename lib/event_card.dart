import 'package:flutter/material.dart';
import 'event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isSmall;
  final Function()? onTap;

  const EventCard({
    Key? key,
    required this.event,
    this.isSmall = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: isSmall ? 6.0 : 8.0,
        horizontal: isSmall ? 4.0 : 8.0, // Reduce horizontal margin for small cards
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: isSmall ? 2.0 : 4.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: isSmall ? 130.0 : 200.0, // Adjust as needed for your grid
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.asset(
                    event.imageUrl ?? 'assets/default_event.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 32.0),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmall ? 6.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? 'Event',
                      style: TextStyle(
                        fontSize: isSmall ? 12.0 : 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmall ? 2.0 : 6.0),
                    Text(
                      event.location ?? '',
                      style: TextStyle(
                        fontSize: isSmall ? 10.0 : 13.0,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}