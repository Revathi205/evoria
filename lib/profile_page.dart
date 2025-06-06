// profile_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile.dart';
import 'login_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final UserProfile userProfile;

  const ProfilePage({super.key, required this.userProfile});

  // Updated theme data with image paths instead of icons
  final List<Map<String, dynamic>> defaultThemes = const [
    {'name': 'Wedding', 'image': 'assets/wedding.png'},
    {'name': 'Birthday', 'image': 'assets/birthday.png'},
    {'name': 'Corporate', 'image': 'assets/corporate.png'},
    {'name': 'Outdoor', 'image': 'assets/outdoor.png'},
    {'name': 'Party', 'image': 'assets/party.png'},
    {'name': 'Elegant', 'image': 'assets/elegant.png'},
  ];

  // Updated wishlist data with image paths
  final List<Map<String, dynamic>> defaultWishlist = const [
    {'name': 'Dream Venue', 'image': 'assets/floral3.jpg'},
    {'name': 'Floral Design', 'image': 'assets/floral2.jpg'},
    {'name': 'Lighting Setup', 'image': 'assets/lights2.png'},
    {'name': 'Decoration Ideas', 'image': 'assets/wedding_show.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Edit Profile', 
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w500,
            color: Colors.black
          )
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(),
            _buildStatsSection(context),
            _buildMyEventsSection(),
            _buildSavedThemesGrid(),
            _buildWishlistSection(),
            _buildSettingsSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFED7AA),
                  shape: BoxShape.circle,
                ),
                child: userProfile.imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 32, color: Color(0xFF9A3412))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          userProfile.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEC4899),
                  ),
                  child: const Icon(Icons.add, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            userProfile.name, 
            style: const TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Colors.black
            )
          ),
          const SizedBox(height: 2),
          Text(
            userProfile.role, 
            style: TextStyle(
              fontSize: 12, 
              color: Colors.grey[600],
              fontWeight: FontWeight.w400
            )
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDashboardItem(context, '23', 'Events Created'),
          _buildDashboardItem(context, '45', 'Events Attended'),
          _buildDashboardItem(context, '120', 'Followers'),
          _buildDashboardItem(context, '110', 'Following'),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            count, 
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.black
            )
          ),
          const SizedBox(height: 2),
          Text(
            label, 
            style: TextStyle(
              color: Colors.grey[600], 
              fontSize: 10,
              fontWeight: FontWeight.w400
            )
          ),
        ],
      ),
    );
  }

  Widget _buildMyEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'My Events',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (userProfile.myEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'No events created yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24.0),
              itemCount: userProfile.myEvents.length,
              itemBuilder: (context, index) {
                final event = userProfile.myEvents[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Colors.grey[300]),
                            const SizedBox(width: 4),
                            Text(
                              "${event.date.day}/${event.date.month}/${event.date.year}",
                              style: TextStyle(color: Colors.grey[300], fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSavedThemesGrid() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Themes',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            TextButton(
              onPressed: () {
                // Add functionality to view all themes
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFEC4899),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: defaultThemes.length > 6 ? 6 : defaultThemes.length,
        itemBuilder: (context, index) {
          final theme = defaultThemes[index];
          
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Background image - FIXED: Only use Image.asset
                      Image.asset(
                        theme['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          // Better error handling with debugging info
                          print('Failed to load asset: ${theme['image']}');
                          print('Error: $error');
                          return Container(
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[600],
                                  size: 30,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  theme['name'],
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Overlay with theme name
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          theme['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Add plus icon for themes
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xFFEC4899),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 24),
    ],
  );
}

 Widget _buildWishlistSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Wishlist / Inspiration',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            TextButton(
              onPressed: () {
                // Add functionality to add to wishlist
              },
              child: Text(
                'Add More',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFEC4899),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: defaultWishlist.take(4).map((item) { // Only show default items
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Background image - FIXED: Only use Image.asset
                          Image.asset(
                            item['image'],
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Failed to load wishlist asset: ${item['image']}');
                              print('Error: $error');
                              return Container(
                                color: Colors.grey[300],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[600],
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Overlay with item name
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add plus icon for wishlist items
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: Color(0xFFEC4899),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
} 
  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingItem('Notifications', Icons.notifications_none),
        _buildSettingItem('Privacy', Icons.lock_outline),
        _buildSettingItem('Help', Icons.help_outline),
        Divider(
          color: Colors.grey[200],
          thickness: 1,
          height: 24,
          indent: 24,
          endIndent: 24,
        ),
        _buildLogoutButton(context),
      ],
    );
  }
  
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          // Show confirmation dialog
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Logout', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
          
          // Proceed with logout if confirmed
          if (shouldLogout == true) {
            try {
              // Sign out from Firebase Auth
              await FirebaseAuth.instance.signOut();
              
              // Clear login status
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              
              // Navigate back to login screen using MaterialPageRoute
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginSignupScreen()),
                (Route<dynamic> route) => false,
              );
              
            } catch (e) {
              // Show error message if logout fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to logout: ${e.toString()}')),
              );
            }
          }
        },
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[400], size: 20),
            const SizedBox(width: 16),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[700], size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.grey[700], size: 20),
        ],
      ),
    );
  }
}