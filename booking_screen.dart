import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_final_project/services/firestore_services.dart';
import 'payment_option_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic>? providerData;
  const BookingScreen({super.key, this.providerData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? selectedService;

  final List<String> services = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Cleaner',
    'Painter',
  ];

  final FirestoreService _firestoreService = FirestoreService();

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimations = List.generate(7, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.15, 1.0, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(7, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.15, 1.0, curve: Curves.easeIn),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date and time")),
        );
        return;
      }
      if (selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a service")),
        );
        return;
      }

      // Firestore me data save
      await _firestoreService.saveBooking(
        customerId: FirebaseAuth.instance.currentUser!.uid,
        customerName: _nameController.text,
        address: _addressController.text,
        bookingDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        bookingTime: _selectedTime!.format(context),
        serviceName: selectedService!, // dropdown se value
        notes: _notesController.text,
      );

      // Navigate to Payment screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentOptionScreen()),
      );
    }
  }

  Widget _buildAnimatedField(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(position: _slideAnimations[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa0e9fd), Color(0xFF00bfa5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Book Your Service",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    _buildAnimatedField(
                      0,
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Your Name",
                          floatingLabelStyle:
                              const TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Enter your name" : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address
                    _buildAnimatedField(
                      1,
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: "Address",
                          floatingLabelStyle:
                              const TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Enter address" : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Service
                    _buildAnimatedField(
                      2,
                      DropdownButtonFormField<String>(
                        value: selectedService,
                        hint: const Text("Select Service"),
                        items: services.map((service) {
                          return DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedService = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        validator: (val) =>
                            val == null ? "Please select a service" : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date
                    _buildAnimatedField(
                      3,
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "Select Date"
                                    : DateFormat('yyyy-MM-dd')
                                        .format(_selectedDate!),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.teal)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Time
                    _buildAnimatedField(
                      4,
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTime == null
                                    ? "Select Time"
                                    : _selectedTime!.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.access_time, color: Colors.teal)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Notes
                    _buildAnimatedField(
                      5,
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: "Notes (optional)",
                          floatingLabelStyle:
                              const TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button
                    _buildAnimatedField(
                      6,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Confirm Booking",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
