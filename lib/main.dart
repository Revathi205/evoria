import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'app_theme.dart';

import 'home_screen.dart';
import 'event_details_screen.dart';
import 'vendor_detail_screen.dart';
import 'user_profile.dart';
import 'event.dart';
import 'vendor.dart';
import 'EventCreationScreen.dart';
import 'login_signup_screen.dart'; // Changed to import login_signup_screen instead of login_screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Check login status
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Dummy UserProfile to pass to HomeScreen
    final dummyUserProfile = UserProfile(
      id: 'revathi@example.com',
      name: 'Revathi',
      imageUrl: 'https://example.com/profile.jpg',
      role: 'User',
      eventsPlanned: 5,
      eventsAttended: 12,
      followers: 45,
      myEvents: [
        Event(
          id: '1',
          title: 'Birthday Party',
          date: 'May 15, 2025',
          time: '6:00 PM',
          location: 'Home',
          imageUrl: 'https://example.com/event1.jpg',
          description: 'My birthday celebration',
          category: 'Celebration',
        ),
        Event(
          id: '2',
          title: 'Wedding Anniversary',
          date: 'June 20, 2025',
          time: '7:30 PM',
          location: 'Grand Hotel',
          imageUrl: 'https://example.com/event2.jpg',
          description: 'Anniversary celebration',
          category: 'Anniversary',
        ),
      ],
      savedThemes: [
        'https://example.com/theme1.jpg',
        'https://example.com/theme2.jpg',
        'https://example.com/theme3.jpg',
        'https://example.com/theme4.jpg',
      ],
      wishlist: [
        'Beach wedding venue',
        'Vintage car for entrance',
        'Professional photographer',
        'Custom cake design'
      ],
    );

    return MaterialApp(
      title: 'Evoria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Change the initial route based on login status
      home: isLoggedIn 
          ? HomeScreen(userProfile: dummyUserProfile) 
          : const SplashScreen(), // Use SplashScreen as the entry point
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login_signup': (context) => LoginSignupScreen(),
        '/main': (context) => HomeScreen(userProfile: dummyUserProfile),
        '/event_details': (context) => EventDetailsScreen(),
        '/event_creation': (context) => const EventCreationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/vendor_details') {
          final vendor = settings.arguments as Vendor;
          return MaterialPageRoute(
            builder: (context) => VendorDetailsScreen(vendor: vendor),
          );
        }
        return null; // fallback if route not matched
      },
    );
  }
}