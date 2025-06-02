import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import your HomeScreen and UserProfile
import 'home_screen.dart';
import 'user_profile.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _passwordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }
    
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      
      // Create a UserProfile object (you might want to fetch this from Firestore in a real app)
      final userProfile = UserProfile(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? 'User',
        imageUrl: userCredential.user!.photoURL ?? '',
        role: 'User',
        eventsPlanned: 0,
        eventsAttended: 0,
        followers: 0,
        myEvents: [],
        savedThemes: [],
        wishlist: [],
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
      
      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userProfile: userProfile),
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 100, height: 100),
                const SizedBox(height: 25),
                Text(
                  'WELCOME BACK !',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'LOGIN TO CONTINUE',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 30),

                /// EMAIL
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMAIL',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// PASSWORD
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSWORD',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                /// REMEMBER + FORGOT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          fillColor: MaterialStateProperty.all(Color(0xFFD4AF37)),
                          checkColor: Colors.white,
                        ),
                        Text(
                          'Remember me',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// LOGIN BUTTON
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFF1F3A5F),
                  ),
                  child: TextButton(
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}