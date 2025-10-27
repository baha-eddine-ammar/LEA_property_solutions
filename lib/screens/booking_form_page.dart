import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'trips_page.dart';
import '../theme/app_theme.dart';

class BookingFormPage extends StatefulWidget {
  final PropertyListing property;

  const BookingFormPage({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  // Selected dates
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default dates from property
    final datesParts = widget.property.dates.split(' - ');
    if (datesParts.length == 2) {
      _checkInDate = _parseDate(datesParts[0]);
      _checkOutDate = _parseDate(datesParts[1]);
    }
  }

  DateTime? _parseDate(String dateStr) {
    final months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };

    final parts = dateStr.split(' ');
    if (parts.length == 2) {
      final month = months[parts[0]];
      final day = int.tryParse(parts[1]);
      if (month != null && day != null) {
        return DateTime(DateTime.now().year, month, day);
      }
    }
    return null;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  int _calculateNights() {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  double _calculateTotal() {
    final nights = _calculateNights();
    final basePrice = widget.property.price;
    final cleaningFee = basePrice * 0.1; // 10% of base price
    final serviceFee = basePrice * 0.15; // 15% of base price
    return (basePrice * nights) + cleaningFee + serviceFee;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final initialDate = isCheckIn ? (_checkInDate ?? DateTime.now()) : 
                                   (_checkOutDate ?? (_checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1))));
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate?.add(const Duration(days: 1)) ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          // If check-out date is before new check-in date, update it
          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = _checkInDate!.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nights = _calculateNights();
    final total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete your booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property summary
                      _buildPropertySummary(),
                      const Divider(height: 32),

                      // Trip dates
                      const Text(
                        'Your trip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Dates selection
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateSelector(
                              label: 'Check-in',
                              date: _checkInDate,
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateSelector(
                              label: 'Check-out',
                              date: _checkOutDate,
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Guest count
                      _buildGuestCounter(),
                      const Divider(height: 32),

                      // Guest information
                      const Text(
                        'Guest information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Full name',
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emailController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Phone number',
                          hintText: 'Enter your phone number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const Divider(height: 32),

                      // Payment information
                      const Text(
                        'Payment information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Card number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          prefixIcon: const Icon(Icons.credit_card),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your card number';
                          }
                          if (value.replaceAll(' ', '').length < 16) {
                            return 'Please enter a valid card number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryDateController,
                              decoration: AppTheme.inputDecoration(
                                labelText: 'Expiry date',
                                hintText: 'MM/YY',
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _ExpiryDateFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length < 5) {
                                  return 'Invalid date';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              decoration: AppTheme.inputDecoration(
                                labelText: 'CVV',
                                hintText: '123',
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length < 3) {
                                  return 'Invalid CVV';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _cardHolderController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Cardholder name',
                          hintText: 'Name as it appears on card',
                          prefixIcon: const Icon(Icons.account_circle_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cardholder name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Price details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildPriceRow(
                              '${widget.property.price.toStringAsFixed(0)} x $nights ${nights == 1 ? 'night' : 'nights'}',
                              (widget.property.price * nights).toStringAsFixed(0),
                            ),
                            const SizedBox(height: 8),
                            _buildPriceRow(
                              'Cleaning fee',
                              (widget.property.price * 0.1).toStringAsFixed(0),
                            ),
                            const SizedBox(height: 8),
                            _buildPriceRow(
                              'Service fee',
                              (widget.property.price * 0.15).toStringAsFixed(0),
                            ),
                            const Divider(height: 24),
                            _buildPriceRow(
                              'Total (USD)',
                              total.toStringAsFixed(0),
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Book button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Confirm and pay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPropertySummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.property.imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.property.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.property.location,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.property.rating} · ${widget.property.bedrooms} ${widget.property.bedrooms > 1 ? 'bedrooms' : 'bedroom'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? _formatDate(date) : 'Select date',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guests',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_guestCount ${_guestCount == 1 ? 'guest' : 'guests'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _guestCount > 1
                    ? () {
                        setState(() {
                          _guestCount--;
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: _guestCount > 1 ? Colors.black : Colors.grey[300],
                ),
              ),
              Text(
                '$_guestCount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: _guestCount < (widget.property.bedrooms * 2)
                    ? () {
                        setState(() {
                          _guestCount++;
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: _guestCount < (widget.property.bedrooms * 2)
                      ? Colors.black
                      : Colors.grey[300],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$$amount',
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_checkInDate == null || _checkOutDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select check-in and check-out dates')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate network request
      Future.delayed(const Duration(seconds: 2), () {
        // Create booking
        final dates = '${_formatDate(_checkInDate!)} - ${_formatDate(_checkOutDate!)}';
        final bookedProperty = BookedProperty(
          property: widget.property,
          dates: dates,
          totalPrice: _calculateTotal(),
          bookingDate: DateTime.now(),
        );

        setState(() {
          _isLoading = false;
        });

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your booking has been confirmed. You can view your booking details in the Trips section.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Booking reference: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripsPage(
                        bookedProperties: [bookedProperty],
                      ),
                    ),
                  );
                },
                child: const Text('View Trips'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to property details
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }
}

// Custom formatters for credit card input
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i != text.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
