import 'package:evoria_app/vendor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:evoria_app/vendor.dart';
import 'package:evoria_app/event_service.dart' hide Vendor;
import 'package:evoria_app/mock_data.dart' as mock_data;


class VendorsScreen extends StatefulWidget {
  final String? eventId; // Optional event ID to filter vendors or add vendors to event
  final bool showAddToEventOption; // Whether to show "Add to Event" option
  
  const VendorsScreen({
    Key? key, 
    this.eventId,
    this.showAddToEventOption = false,
  }) : super(key: key);

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final EventService _eventService = EventService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Vendor> _allVendors = [];
  List<Vendor> _filteredVendors = [];
  List<Vendor> _eventVendors = []; // Vendors already in the event
  
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Venue', 'Catering', 'Photography', 'Florist', 'Entertainment', 'Decor', 'Planning'];

  @override
void initState() {
  super.initState();
  _loadMockData();
}

void _loadMockData() {
  setState(() {
    _isLoading = true;
  });
  
  // Load mock data
  _allVendors = mock_data.MockData.vendors; // Use the correct variable name from mock_data.dart
  _filteredVendors = List.from(_allVendors);
  print('Total vendors loaded: ${_allVendors.length}');
  
  setState(() {
    _isLoading = false;
  });
}

// Update your _refreshData method to use mock data too:
// (Removed duplicate _refreshData)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all available vendors
      _allVendors = (await _eventService.getAllVendors()).cast<Vendor>();
      
      // If eventId is provided, also load vendors already in the event
      if (widget.eventId != null) {
        _eventVendors = (await _eventService.getEventVendors(widget.eventId!)).cast<Vendor>();
      }
      
      // Initialize filtered vendors
      _filteredVendors = List.from(_allVendors);
      
    } catch (e) {
      print('Error loading vendors: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading vendors: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _filterVendors(String query) {
    final filtered = _allVendors.where((vendor) {
      final nameMatch = vendor.name.toLowerCase().contains(query.toLowerCase());
      final categoryMatch = _selectedCategory == 'All' || vendor.category == _selectedCategory;
      final descriptionMatch = vendor.description.toLowerCase().contains(query.toLowerCase());
      return (nameMatch || descriptionMatch) && categoryMatch;
    }).toList();

    setState(() {
      _filteredVendors = filtered;
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterVendors(_searchController.text);
    });
  }

  bool _isVendorInEvent(Vendor vendor) {
    return _eventVendors.any((eventVendor) => eventVendor.id == vendor.id);
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Vendors',
          style: TextStyle(
            fontFamily: 'Spline Sans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isLoading ? Icons.refresh : Icons.refresh_outlined,
            ),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Category Filter
          _buildCategoryFilter(),
          
          const SizedBox(height: 16),
          
          // Vendors List
          Expanded(
            child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF00861)),
                  ),
                )
              : _filteredVendors.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredVendors.length,
                        itemBuilder: (context, index) {
                          final vendor = _filteredVendors[index];
                          return _buildVendorCard(vendor);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search vendors...',
          hintStyle: const TextStyle(
            fontFamily: 'Spline Sans',
            color: Color(0xFF666666),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF666666),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(
          fontFamily: 'Spline Sans',
          fontSize: 14,
        ),
        onChanged: _filterVendors,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _buildCategoryChip(category);
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            fontFamily: 'Spline Sans',
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => _filterByCategory(category),
        selectedColor: const Color(0xFFF00861),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No vendors found',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or category filter',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
                _searchController.clear();
                _filteredVendors = List.from(_allVendors);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF00861),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reset Filters',
              style: TextStyle(
                fontFamily: 'Spline Sans',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
    final isInEvent = _isVendorInEvent(vendor);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailsScreen(
                vendorData: vendor,
                eventId: widget.eventId,
              ),
            ),
          ).then((_) {
            // Refresh data when returning from vendor details
            _loadData();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Vendor Image/Icon with Status Badge
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: vendor.imageUrl.isNotEmpty && vendor.imageUrl.startsWith('assets')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              vendor.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  _getCategoryIcon(vendor.category),
                                  size: 30,
                                  color: Colors.grey[600],
                                );
                              },
                            ),
                          )
                        : Icon(
                            _getCategoryIcon(vendor.category),
                            size: 30,
                            color: Colors.grey[600],
                          ),
                  ),
                  
                  // Featured badge
                  if (vendor.isFeatured)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF00861),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'F',
                          style: TextStyle(
                            fontFamily: 'Spline Sans',
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Vendor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Event Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vendor.name,
                            style: const TextStyle(
                              fontFamily: 'Spline Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.eventId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isInEvent ? Colors.green : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isInEvent ? 'Added' : 'Available',
                              style: TextStyle(
                                fontFamily: 'Spline Sans',
                                color: isInEvent ? Colors.white : Colors.grey[700],
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category and Location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF00861).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            vendor.category,
                            style: const TextStyle(
                              fontFamily: 'Spline Sans',
                              fontSize: 12,
                              color: Color(0xFFF00861),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (vendor.location.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              vendor.location,
                              style: TextStyle(
                                fontFamily: 'Spline Sans',
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Rating and Price
                    Row(
                      children: [
                        if (vendor.rating > 0) ...[
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vendor.rating.toString(),
                            style: const TextStyle(
                              fontFamily: 'Spline Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (vendor.rating > 0 && vendor.priceRange != null)
                          const SizedBox(width: 16),
                        if (vendor.priceRange != null && vendor.priceRange!.isNotEmpty)
                          Text(
                            vendor.priceRange!,
                            style: TextStyle(
                              fontFamily: 'Spline Sans',
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'florist':
        return Icons.local_florist;
      case 'catering':
        return Icons.restaurant;
      case 'venue':
        return Icons.location_city;
      case 'photography':
        return Icons.camera_alt;
      case 'entertainment':
      case 'music':
        return Icons.music_note;
      case 'decor':
      case 'decoration':
        return Icons.format_paint;
      case 'planning':
        return Icons.event_note;
      case 'transportation':
        return Icons.directions_car;
      case 'bar services':
        return Icons.local_bar;
      case 'lighting':
        return Icons.lightbulb;
      default:
        return Icons.store;
    }
  }
}