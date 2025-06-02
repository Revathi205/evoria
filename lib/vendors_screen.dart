import 'package:flutter/material.dart';
import 'vendor.dart';
import '../mock_data.dart';
import 'vendor_detail_screen.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({Key? key}) : super(key: key);

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Vendor> _filteredVendors = [];
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Venue', 'Catering', 'Photography', 'Florist', 'Decor'];

  @override
  void initState() {
    super.initState();
    // Initialize with vendors from MockData
    _filteredVendors = MockData.vendors;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVendors(String query) {
    final filtered = MockData.vendors.where((vendor) {
      final nameMatch = vendor.name.toLowerCase().contains(query.toLowerCase());
      final categoryMatch = _selectedCategory == 'All' || vendor.category == _selectedCategory;
      return nameMatch && categoryMatch;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Vendors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _filterVendors,
            ),
          ),
          
          // Category Filter
          SizedBox(
            height: 40,
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
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _filterByCategory(category),
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.pink[100],
                    checkmarkColor: Colors.pink,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.pink : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Vendors List
          Expanded(
            child: _filteredVendors.isEmpty
              ? const Center(child: Text('No vendors found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = _filteredVendors[index];
                    return _buildVendorCard(context, vendor);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, Vendor vendor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailsScreen(vendor: vendor),
            ),
          );
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
                child: vendor.imageUrl.startsWith('assets')
                  ? Image.asset(
                      vendor.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        _getCategoryIcon(vendor.category),
                        size: 48,
                        color: Colors.grey[500],
                      ),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vendor.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vendor.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    vendor.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
        return Icons.format_paint;
      default:
        return Icons.store;
    }
  }
}