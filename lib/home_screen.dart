import 'package:flutter/material.dart';
import '../event_card.dart';
import '../mock_data.dart';
import 'event.dart';
import 'profile_page.dart';
import 'calendar_screen.dart';
import 'explore_screen.dart';
import 'user_profile.dart';
import 'vendors_screen.dart'; 
import "EventCreationScreen.dart";

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;

  const HomeScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeContent(context),
      CalendarScreen(),
      ExploreScreen(),
      VendorsScreen(),
      ProfilePage(userProfile: widget.userProfile),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventCreationScreen(),
                  ),
                );
              },
              backgroundColor: Colors.pink,
              label: const Text('Quick Event Creation'),
              icon: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Vendors'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Evoria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          
          // Main Content - Scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Banner
                    Container(
                      height: 150,
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/hero_banner.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.pink.withOpacity(0.3),
                                  Colors.pink.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Text(
                              'Welcome to Evoria.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Featured Events Section (First 4 events)
                    _buildSectionTitle('Featured Events'),
                    SizedBox(height: 12),
                    _buildFeaturedEventsGrid(context),
                    SizedBox(height: 24),
                    
                    // Fun & Unique Section (Events 5-7)
                    _buildSectionTitle('Fun & Unique'),
                    SizedBox(height: 12),
                    _buildHorizontalEventList(context, MockData.sampleEvents.sublist(2, 7)),
                    SizedBox(height: 24),
                    
                    // Nearby Events Section (Events 8-13)
                    _buildSectionTitle('Nearby This Weekend'),
                    SizedBox(height: 12),
                    _buildEventGrid(context, MockData.sampleEvents.sublist(7, MockData.sampleEvents.length)),
                    SizedBox(height: 24),
                    
                    // All Events Section - Horizontal Scroll
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('All Events'),
                        TextButton(
                          onPressed: () {
                            // Navigate to explore screen
                            setState(() {
                              _currentIndex = 2;
                              _pageController.jumpToPage(2);
                            });
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildAllEventsHorizontalList(context),
                    SizedBox(height: 80), // Bottom padding for FAB clearance
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Featured Events Grid - 2x2 grid (First 4 events)
  Widget _buildFeaturedEventsGrid(BuildContext context) {
    final featuredEvents = MockData.sampleEvents.take(4).toList();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: featuredEvents.length,
      itemBuilder: (context, index) {
        final event = featuredEvents[index];
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
    );
  }

  // Horizontal scrolling list for Fun & Unique events
  Widget _buildHorizontalEventList(BuildContext context, List<Event> events) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: 12),
            child: EventCard(
              event: event,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/event_details',
                  arguments: event,
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Generic Event Grid - 3 columns
  Widget _buildEventGrid(BuildContext context, List<Event> events) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          isSmall: true,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/event_details',
              arguments: event,
            );
          },
        );
      },
    );
  }

  // All Events Horizontal List
  Widget _buildAllEventsHorizontalList(BuildContext context) {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MockData.sampleEvents.length,
        itemBuilder: (context, index) {
          final event = MockData.sampleEvents[index];
          return Container(
            width: 180,
            margin: EdgeInsets.only(right: 12),
            child: EventCard(
              event: event,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/event_details',
                  arguments: event,
                );
              },
            ),
          );
        },
      ),
    );
  }
}