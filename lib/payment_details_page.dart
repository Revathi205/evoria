import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final TextEditingController _discountController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';
  bool _showDiscountError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    _buildProgressSection(),
                    
                    // Ticket Types section
                    _buildTicketTypesSection(),
                    
                    // Discount code section
                    _buildDiscountSection(),
                    
                    // Payment options section
                    _buildPaymentOptionsSection(),
                    
                    // Summary card
                    _buildSummaryCard(),
                    
                    // Event packages section
                    _buildEventPackagesSection(),
                  ],
                ),
              ),
            ),
            
            // Bottom action buttons
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              child: const Icon(Icons.arrow_back, color: Color(0xFF1C0D12)),
            ),
          ),
          const Expanded(
            child: Text(
              'Payment Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Spline Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C0D12),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completing Your Purchase',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C0D12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE6D1D9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE63075),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Ticket Types',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C0D12),
            ),
          ),
        ),
        _buildTicketItem('General Admission', '150 Available', '\$75'),
        _buildTicketItem('VIP', '50 Available', '\$150'),
        _buildTicketItem('Premium', '20 Available', '\$250'),
      ],
    );
  }

  Widget _buildTicketItem(String type, String availability, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontFamily: 'Spline Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C0D12),
                  ),
                ),
                Text(
                  availability,
                  style: const TextStyle(
                    fontFamily: 'Spline Sans',
                    fontSize: 14,
                    color: Color(0xFF964F6B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 16,
              color: Color(0xFF1C0D12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2E8ED),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: TextField(
                      controller: _discountController,
                      decoration: const InputDecoration(
                        hintText: 'Discount Code',
                        hintStyle: TextStyle(
                          color: Color(0xFF964F6B),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2E8ED),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Color(0xFF964F6B),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          if (_showDiscountError)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Invalid discount code. Please try again.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF964F6B),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Payment Options',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C0D12),
            ),
          ),
        ),
        _buildPaymentOption('Credit Card', Icons.credit_card),
        _buildPaymentOption('Gpay', Icons.payment),
        _buildPaymentOption('Phonepay', Icons.phone_android),
      ],
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    bool isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF2E8ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1C0D12)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: const TextStyle(
                  fontFamily: 'Spline Sans',
                  fontSize: 16,
                  color: Color(0xFF1C0D12),
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFE63075) : const Color(0xFF964F6B),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Color(0xFFE63075),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 247,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.4),
          ],
        ),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Total: \$225',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '3 Tickets (2 General, 1 VIP) · No Discounts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Event Packages',
            style: TextStyle(
              fontFamily: 'Spline Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C0D12),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exclusive Package',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF964F6B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Premium Event Experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C0D12),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Access to VIP areas, concierge services.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF964F6B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 130,
                height: 91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Handle proceed to pay
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE63075),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Proceed to Pay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFAF7FA),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Handle save for later
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2E8ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Save for Later',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C0D12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              // Handle view event details
            },
            child: const Text(
              'View Event Details',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF964F6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}