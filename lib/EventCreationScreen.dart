import 'package:flutter/material.dart';
import 'dart:ui';
import 'event.dart';
import 'firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({Key? key}) : super(key: key);

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  // Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State variables
  String _eventType = 'Celebration';
  Color _selectedColor = const Color(0xFFF8E71C); // Yellow as default
  List<Color> _colorOptions = [
    const Color(0xFFF8E71C), // Yellow
    const Color(0xFFFF5318), // Orange
    const Color(0xFFF75A97), // Pink
    const Color(0xFF51E5FF), // Blue
    const Color(0xFF2BD233), // Green
  ];
  
  String _selectedTheme = 'Classic';
  bool _enableRSVP = false;
  bool _enableBudgetTracker = false;
  bool _enableTodoChecklist = false;
  bool _isCreating = false;

  // Store selected date and time separately for easier handling
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F9),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Details Section
                    _buildSectionTitle('Event Details'),
                    _buildTextInput(_eventNameController, 'Event Name'),
                    _buildDateTimeInput(),
                    _buildEventTypeSelector(),
                    _buildTextInput(_locationController, 'Location'),
                    
                    // Customization & Theme Section
                    _buildSectionTitle('Customization & Theme'),
                    _buildThemeTabs(),
                    _buildColorPicker(),
                    _buildTextArea(_notesController, 'Add notes'),
                    
                    // Vendors Section
                    _buildSectionTitle('Vendors'),
                    _buildVendorsGallery(),
                    _buildAddCustomItem('Add a custom vendor', Icons.add),
                    
                    // Media Section
                    _buildSectionTitle('Media'),
                    _buildAddCustomItem('Upload images', Icons.image),
                    
                    // Guestlist Section
                    _buildSectionTitle('Guestlist'),
                    _buildAddCustomItem('Add Guests from Contacts', Icons.add),
                    _buildGuestAvatars(),
                    
                    // Extras Section
                    _buildSectionTitle('Extras'),
                    _buildToggleOption('Enable RSVP', _enableRSVP, (value) {
                      setState(() {
                        _enableRSVP = value;
                      });
                    }),
                    _buildToggleOption('Budget Tracker', _enableBudgetTracker, (value) {
                      setState(() {
                        _enableBudgetTracker = value;
                      });
                    }),
                    _buildToggleOption('To-Do Checklist', _enableTodoChecklist, (value) {
                      setState(() {
                        _enableTodoChecklist = value;
                      });
                    }),
                    
                    // Event Summary Section
                    _buildSectionTitle('Event Summary'),
                    _buildEventSummaryCard(),
                    
                    // Bottom padding
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF8F9),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back, color: Color(0xFF1B0E12)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Create Event',
                style: TextStyle(
                  color: const Color(0xFF1B0E12),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),
          Container(width: 48), // Empty container for balance
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B0E12),
          letterSpacing: -0.015,
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String placeholder) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF3E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: const Color(0xFF974E67)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF3E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(
                  hintText: 'Date & Time',
                  hintStyle: TextStyle(color: const Color(0xFF974E67)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onTap: () async {
                  // Show date time picker
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  
                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    
                    if (pickedTime != null) {
                      final dateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      
                      setState(() {
                        _selectedDateTime = dateTime;
                        _dateTimeController.text = '${_formatDate(dateTime)} · ${_formatTime(pickedTime)}';
                      });
                    }
                  }
                },
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.calendar_today, 
                color: const Color(0xFF974E67),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildEventTypeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildEventTypeOption('Celebration'),
            _buildEventTypeOption('Gathering'),
            _buildEventTypeOption('Corporate'),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeOption(String type) {
    final isSelected = _eventType == type;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _eventType = type;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCF8F9) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  )]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1B0E12) : const Color(0xFF974E67),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE7D0D7),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildThemeTab('Classic', isSelected: _selectedTheme == 'Classic'),
          _buildThemeTab('Modern', isSelected: _selectedTheme == 'Modern'),
          _buildThemeTab('Minimal', isSelected: _selectedTheme == 'Minimal'),
        ],
      ),
    );
  }

  Widget _buildThemeTab(String theme, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE6195D) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          theme,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1B0E12) : const Color(0xFF974E67),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 20,
        children: _colorOptions.map((color) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedColor == color 
                      ? const Color(0xFFFCF8F9) 
                      : const Color(0xFFE7D0D7),
                  width: _selectedColor == color ? 3 : 1,
                ),
                boxShadow: _selectedColor == color
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1B0E12).withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: const Offset(0, 0),
                        )
                      ]
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String placeholder) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        constraints: BoxConstraints(minHeight: 144),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          maxLines: null,
          minLines: 4,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: const Color(0xFF974E67)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildVendorsGallery() {
    final vendors = [
      {'name': 'Catering', 'image': 'assets/catering.png'},
      {'name': 'Decor', 'image': 'assets/decor.png'},
      {'name': 'Entertainment', 'image': 'assets/entertainment.png'},
      {'name': 'Audio Visual', 'image': 'assets/audio_visual.png'},
    ];

    return Container(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: index < vendors.length - 1 ? 16 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      vendors[index]['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3E7EB),
                          child: Icon(
                            Icons.image,
                            color: const Color(0xFF974E67),
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vendors[index]['name']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1B0E12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCustomItem(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Handle tap - you can implement specific functionality here
          _showInfoMessage('$label functionality coming soon!');
        },
        child: Container(
          height: 56,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E7EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1B0E12)),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF1B0E12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestAvatars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(
          5,
          (index) => Container(
            margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3E7EB),
              border: Border.all(color: const Color(0xFFFCF8F9), width: 3),
            ),
            child: Icon(
              Icons.person,
              color: const Color(0xFF974E67),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF1B0E12),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFE6195D),
            activeTrackColor: const Color(0xFFE6195D),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFF3E7EB),
          ),
        ],
      ),
    );
  }

  Widget _buildEventSummaryCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedColor.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _eventType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _eventNameController.text.isEmpty ? 'Birthday Bash' : _eventNameController.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _dateTimeController.text.isEmpty && _locationController.text.isEmpty 
                    ? 'July 23 · 7PM - 11PM · Central Park'
                    : '${_dateTimeController.text.isEmpty ? 'Date TBD' : _dateTimeController.text} · ${_locationController.text.isEmpty ? 'Location TBD' : _locationController.text}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFCF8F9),
      child: ElevatedButton(
        onPressed: _isCreating ? null : _createEvent,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6195D),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          minimumSize: Size(double.infinity, 48),
        ),
        child: _isCreating
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Create Event',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
      ),
    );
  }

  // Form validation
  bool _validateForm() {
    if (_eventNameController.text.trim().isEmpty) {
      _showErrorMessage('Please enter an event name');
      return false;
    }
    
    if (_dateTimeController.text.trim().isEmpty) {
      _showErrorMessage('Please select a date and time');
      return false;
    }
    
    if (_locationController.text.trim().isEmpty) {
      _showErrorMessage('Please enter a location');
      return false;
    }
    
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF51E5FF),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Create event method
  Future<void> _createEvent() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
  final event = Event (
    id: '', // You can optionally set this later from Firestore
    title: _eventNameController.text.trim(),
    description: _eventType,
    time: _dateTimeController.text.trim(),
    imageUrl: '', // Placeholder for now
    date: (_selectedDateTime ?? DateTime.now()).toIso8601String(),
    location: _locationController.text.trim(),
    theme: _selectedTheme,
    enableRSVP: _enableRSVP,
    enableBudgetTracker: _enableBudgetTracker,
    enableTodoChecklist: _enableTodoChecklist,
    createdAt: DateTime.now(),
  );

  final eventId = await FirebaseService.createEvent(event);

  _showSuccessMessage('Event created successfully!');
  
  // Navigate back or to event details
  Navigator.pop(context, eventId);

} catch (e) {
  print("Error creating event: $e");
  _showErrorMessage('Failed to create event: ${e.toString()}');
} finally {
  setState(() {
    _isCreating = false;
  });
}
  }
}