import 'package:evoria_app/event.dart';
import 'package:evoria_app/vendor.dart' as vendor_lib;
import 'package:evoria_app/event_service.dart';
import 'package:evoria_app/vendor_detail_screen.dart';
import 'package:evoria_app/payment_details_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// Removed duplicate vendor.dart import
import 'package:evoria_app/vendors_screen.dart';

class EventOverviewPage extends StatefulWidget {
  final Event event;
  const EventOverviewPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventOverviewPage> createState() => _EventOverviewPageState();
}

class _EventOverviewPageState extends State<EventOverviewPage>
    with RouteAware, WidgetsBindingObserver {
  final EventService _eventService = EventService();
  List<vendor_lib.Vendor> _eventVendors = [];
  bool _isLoadingVendors = true;
  late Event _currentEvent;
  Timer? _refreshTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
    WidgetsBinding.instance.addObserver(this);
    _loadEventVendors();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      _loadEventVendors();
    }
  }

  @override
  void didPopNext() {
    // Called when returning from another page
    // Refresh vendor list when returning from vendor detail screen
    if (!_isDisposed) {
      _loadEventVendors();
    }
  }

  void _startAutoRefresh() {
    // Auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isDisposed && mounted) {
        _loadEventVendors();
      }
    });
  }

  Future<void> _loadEventVendors() async {
    if (_isDisposed) return;

    setState(() {
      _isLoadingVendors = true;
    });

    try {
      var vendorsRaw = await _eventService.getEventVendors(_currentEvent.id);
      List<vendor_lib.Vendor> vendors = vendorsRaw.cast<vendor_lib.Vendor>();
      if (!_isDisposed && mounted) {
        setState(() {
          _eventVendors = vendors;
        });
      }
    } catch (e) {
      print('Error loading vendors: $e');
    } finally {
      if (!_isDisposed && mounted) {
        setState(() {
          _isLoadingVendors = false;
        });
      }
    }
  }

  // Method to manually refresh data
  Future<void> _refreshData() async {
    await _loadEventVendors();
  }

  // Method to navigate to vendor detail screen
  void _navigateToVendorDetail(vendor_lib.Vendor vendor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VendorDetailsScreen(
              vendorData: vendor,
              eventId: _currentEvent.id, // Pass the event ID
            ),
      ),
    ).then((_) {
      // Refresh the vendor list when returning from vendor detail screen
      _loadEventVendors();
    });
  }

  // Method to navigate to add new vendor
  void _navigateToAddVendor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VendorDetailsScreen(
              vendorData: _createEmptyVendor(),
              eventId: _currentEvent.id,
            ),
      ),
    ).then((_) {
      _loadEventVendors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7FA),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header Section
                _buildHeader(context),

                // Hero Image Section
                _buildHeroSection(),

                // Tab Navigation
                _buildTabNavigation(),

                // Event Details Section
                _buildEventDetailsSection(),

                // Vendors Section
                _buildVendorsSection(),

                // Timeline Section (if enabled)
                if (_currentEvent.enableTodoChecklist) _buildTimelineSection(),

                // Quick Actions - REMOVED Add Vendor from here
                _buildQuickActionsSection(),

                // Budget Section (if enabled)
                if (_currentEvent.enableBudgetTracker) _buildBudgetSection(),

                // Categories Grid
                _buildCategoriesGrid(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // Floating Action Button for Payment (only if budget tracker is enabled)
      floatingActionButton:
          _currentEvent.enableBudgetTracker
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailsPage(),
                    ),
                  );
                },
                backgroundColor: const Color(0xFFF00861),
                child: const Icon(Icons.payment, color: Color(0xFFFCF7FA)),
              )
              : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Event Overview',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Spline Sans',
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.width < 400 ? 24 : 28,
                height: 1.25,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
          GestureDetector(
            onTap: _refreshData,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Icon(
                _isLoadingVendors ? Icons.refresh : Icons.refresh_outlined,
                size: 24,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    // Get event color from the stored color value
    Color eventColor = Color(4294502172); // Default yellow
    if (_currentEvent.colorHex != null && _currentEvent.colorHex!.isNotEmpty) {
      try {
        eventColor = Color(
          int.parse(_currentEvent.colorHex!.substring(1), radix: 16) +
              0xFF000000,
        );
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: constraints.maxWidth < 600 ? 200 : 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                eventColor.withOpacity(0.3),
                eventColor.withOpacity(0.7),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentEvent.title.isNotEmpty
                            ? _currentEvent.title
                            : 'Untitled Event',
                        style: TextStyle(
                          fontFamily: 'Spline Sans',
                          fontWeight: FontWeight.w700,
                          fontSize:
                              MediaQuery.of(context).size.width < 400 ? 24 : 28,
                          height: 1.25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentEvent.description} • ${_currentEvent.theme}',
                        style: const TextStyle(
                          fontFamily: 'Spline Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTabItem('Overview', 0),
          const SizedBox(width: 16),
          _buildTabItem('Vendors', 1),
          const SizedBox(width: 16),
          _buildTabItem('Timeline', 2),
        ],
      ),
    );
  }

  Widget _buildSelectedSection() {
    switch (_selectedTabIndex) {
      case 1:
        return _buildVendorsSection();
      case 2:
        return _buildTimelineSection();
      case 0:
      default:
        return Column(
          children: [
            _buildEventDetailsSection(),
            _buildQuickActionsSection(),
            _buildCategoriesGrid(),
            _buildBudgetSection(),
          ],
        );
    }
  }

  int _selectedTabIndex = 0;

  Widget _buildTabItem(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF00861) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Spline Sans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isActive ? Colors.white : const Color(0xFF1C0D12),
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetailsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Details',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF1C0D12),
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Date', _formatDate(_currentEvent.date)),
          _buildDetailRow('Time', _currentEvent.time ?? 'Not set'),
          _buildDetailRow('Location', _currentEvent.location),
          _buildDetailRow(
            'Guests',
            '${_currentEvent.guestCount ?? 0} expected',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Spline Sans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Spline Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vendors',
                style: TextStyle(
                  fontFamily: 'Spline Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF1C0D12),
                ),
              ),
              // SINGLE Add Vendor button - this is the only one we keep
              GestureDetector(
                onTap: _navigateToAddVendor,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF00861),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Add Vendor',
                        style: TextStyle(
                          fontFamily: 'Spline Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoadingVendors)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF00861),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_eventVendors.isEmpty && !_isLoadingVendors)
            Column(
              children: [
                const Text(
                  'No vendors added yet',
                  style: TextStyle(
                    fontFamily: 'Spline Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                // REMOVED - This duplicate "Add Your First Vendor" button
                Text(
                  'Use the "Add Vendor" button above to get started',
                  style: TextStyle(
                    fontFamily: 'Spline Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            )
          else
            Column(
              children:
                  _eventVendors
                      .map((vendor) => _buildVendorItem(vendor))
                      .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildVendorItem(vendor_lib.Vendor vendor) {
    return GestureDetector(
      onTap: () => _navigateToVendorDetail(vendor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF7FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF00861),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.business, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: const TextStyle(
                      fontFamily: 'Spline Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1C0D12),
                    ),
                  ),
                  Text(
                    vendor.category,
                    style: const TextStyle(
                      fontFamily: 'Spline Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF1C0D12),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No tasks added yet',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED - Removed Add Vendor from Quick Actions
  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton('Invite Guests', Icons.person_add, () {
              // Navigate to invite guests page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invite guests functionality coming soon!'),
                ),
              );
            }),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton('View Timeline', Icons.timeline, () {
              // Navigate to timeline page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Timeline view coming soon!')),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to create empty vendor for "add vendor" flow
  vendor_lib.Vendor _createEmptyVendor() {
    return vendor_lib.Vendor(
      id: '', // Empty ID indicates new vendor
      name: '',
      category: '',
      location: '',
      description: '',
      rating: 0.0,
      imageUrl: '',
      images: [],
      tags: [],
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF00861).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF00861).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: const Color(0xFFF00861)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Spline Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFFF00861),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Tracker',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF1C0D12),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No budget set yet',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildCategoriesGrid method in your EventOverviewPage
  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Catering', 'icon': Icons.restaurant},
      {'name': 'Photography', 'icon': Icons.camera_alt},
      {'name': 'Decoration', 'icon': Icons.celebration},
      {'name': 'All Vendors', 'icon': Icons.store}, // Updated this item
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF1C0D12),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  if (category['name'] == 'All Vendors') {
                    // Navigate to VendorsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VendorsScreen(
                              eventId: _currentEvent.id,
                              showAddToEventOption: true,
                            ),
                      ),
                    ).then((_) {
                      // Refresh vendor list when returning
                      _loadEventVendors();
                    });
                  } else {
                    // Navigate to VendorsScreen with category filter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VendorsScreen(
                              eventId: _currentEvent.id,
                              showAddToEventOption: true,
                            ),
                      ),
                    ).then((_) {
                      // Refresh vendor list when returning
                      _loadEventVendors();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 32,
                        color: const Color(0xFFF00861),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Spline Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1C0D12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }
}
