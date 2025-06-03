import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../event_card.dart';
import '../event.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Festival',
    'Wedding',
    'Arts',
    'Food',
    'Dance',
    'Party',
    'Outdoor',
    'Entertainment',
    'Sports',
    'Art',
    'Expo',
    'Corporate',
    'Charity',
  ];
  
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Events', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events, themes, or venues',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_getFilteredEvents().length} events found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_selectedCategory != 'All' || _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _searchController.clear();
                      });
                    },
                    child: Text(
                      'Clear filters',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
              ],
            ),
          ),
          
          // Category Filter - Horizontal Scrolling
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                final eventCount = _getEventCountForCategory(category);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Colors.pink : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[800],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        if (eventCount > 0)
                          Text(
                            '($eventCount)',
                            style: TextStyle(
                              color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Events Grid
          Expanded(
            child: _buildFilteredEventsGrid(),
          ),
        ],
      ),
    );
  }
  
  List<Event> _getFilteredEvents() {
    final searchQuery = _searchController.text.toLowerCase();
    return MockData.sampleEvents.where((event) {
      // Category filter
      if (_selectedCategory != 'All' && event.category != _selectedCategory) {
        return false;
      }
      
      // Search filter
      if (searchQuery.isNotEmpty) {
        return event.title.toLowerCase().contains(searchQuery) ||
               (event.description ?? '').toLowerCase().contains(searchQuery) ||
               event.location.toLowerCase().contains(searchQuery) ||
               event.category.toLowerCase().contains(searchQuery) ||
               (event.tags?.any((tag) => tag.toLowerCase().contains(searchQuery)) ?? false);
      }
      
      return true;
    }).toList();
  }
  
  int _getEventCountForCategory(String category) {
    if (category == 'All') {
      return MockData.sampleEvents.length;
    }
    return MockData.sampleEvents.where((event) => event.category == category).length;
  }
  
  Widget _buildFilteredEventsGrid() {
    final filteredEvents = _getFilteredEvents();
    
    if (filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'No events found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty 
                  ? 'Try different search terms'
                  : 'Try a different category',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'All';
                  _searchController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text('Show All Events'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate network refresh
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {});
      },
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/event_details',
                arguments: event,
              );
            },
          );
        },
      ),
    );
  }
}