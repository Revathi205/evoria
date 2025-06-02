import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_signup_screen.dart';
import 'home_screen.dart';
import 'user_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check login status and navigate accordingly
    _checkLoginAndNavigate();
  }
  
  Future<void> _checkLoginAndNavigate() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if user is logged in
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      // If logged in, fetch user data or create dummy profile
      // This is a simplified example - you should fetch actual user data from Firebase
      final userProfile = UserProfile(
        id: 'current_user_id',
        name: 'Current User',
        imageUrl: '',
        role: 'User',
        eventsPlanned: 0,
        eventsAttended: 0,
        followers: 0,
        myEvents: [],
        savedThemes: [],
        wishlist: [],
      );
      
      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userProfile: userProfile)),
      );
    } else {
      // If not logged in, go to LoginSignupScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}