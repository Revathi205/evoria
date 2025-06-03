import 'package:evoria_app/vendor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:evoria_app/vendor.dart';
import 'package:evoria_app/event_service.dart' hide Vendor;

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
  final List<String> _categories = ['All', 'Venue', 'Catering', 'Photography', 'Florist', 'Decor', 'Music'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
      backgroundColor: const Color(0xFFFCF7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Category Filter
            _buildCategoryFilter(),
            
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
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredVendors.length,
                          itemBuilder: (context, index) {
                            final vendor = _filteredVendors[index];
                            return _buildVendorCard(context, vendor);
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Vendors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Spline Sans',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
          GestureDetector(
            onTap: _refreshData,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _isLoading ? Icons.refresh : Icons.refresh_outlined,
                size: 24,
                color: const Color(0xFF1C0D12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
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
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  fontFamily: 'Spline Sans',
                  color: isSelected ? Colors.white : const Color(0xFF1C0D12),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => _filterByCategory(category),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFF00861),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? const Color(0xFFF00861) : const Color(0xFFE0E0E0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No vendors found',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, Vendor vendor) {
    final isInEvent = _isVendorInEvent(vendor);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailsScreen(
                vendorData: vendor,
                eventId: widget.eventId, // Pass eventId if available
              ),
            ),
          ).then((_) {
            // Refresh data when returning from vendor details
            _loadData();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    // Image or placeholder
                    vendor.imageUrl.isNotEmpty && vendor.imageUrl.startsWith('assets')
                      ? Image.asset(
                          vendor.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Center(
                          child: Icon(
                            _getCategoryIcon(vendor.category),
                            size: 48,
                            color: Colors.grey[500],
                          ),
                        ),
                    
                    // Featured badge
                    if (vendor.isFeatured)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF00861),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              fontFamily: 'Spline Sans',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    
                    // Event status badge
                    if (widget.eventId != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isInEvent ? Colors.green : Colors.grey.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isInEvent ? 'Added' : 'Available',
                            style: const TextStyle(
                              fontFamily: 'Spline Sans',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          vendor.name,
                          style: const TextStyle(
                            fontFamily: 'Spline Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C0D12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (vendor.rating > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              vendor.rating.toString(),
                              style: const TextStyle(
                                fontFamily: 'Spline Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF1C0D12),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Category and Location
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF00861).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vendor.category,
                          style: const TextStyle(
                            fontFamily: 'Spline Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF00861),
                          ),
                        ),
                      ),
                      if (vendor.location.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            vendor.location,
                            style: TextStyle(
                              fontFamily: 'Spline Sans',
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    vendor.description,
                    style: TextStyle(
                      fontFamily: 'Spline Sans',
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Price Range (if available)
                  if (vendor.priceRange != null && vendor.priceRange!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 12,
                          color: Colors.green[600],
                        ),
                        Text(
                          vendor.priceRange!,
                          style: TextStyle(
                            fontFamily: 'Spline Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
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
      case 'music':
        return Icons.music_note;
      case 'decor':
      case 'decoration':
        return Icons.format_paint;
      default:
        return Icons.store;
    }
  }
}