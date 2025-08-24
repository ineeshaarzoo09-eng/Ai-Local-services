import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_final_project/chatbot_screen.dart';
import 'package:my_final_project/profile_screen.dart';
import 'package:my_final_project/worker_list_screen.dart';
import 'support_screen.dart';
import 'booking_history_screen.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 0; // for navbar

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.plumbing, 'label': 'Plumber'},
    {'icon': Icons.electrical_services, 'label': 'Electrician'},
    {'icon': Icons.cleaning_services, 'label': 'Cleaner'},
    {'icon': Icons.format_paint, 'label': 'Painter'},
    {'icon': Icons.build, 'label': 'Mason'},
    {'icon': Icons.computer, 'label': 'IT Support'},
    {'icon': Icons.carpenter, 'label': 'Carpenter'},
    {'icon': Icons.pest_control, 'label': 'Pest Control'},
  ];

  late List<Map<String, dynamic>> filteredCategories;

  // Workers Data
  
    final Map<String, List<Map<String, String>>> workersByCategory = {
  'Plumber': [
    {
      'name': 'Usman Plumber',
      'experience': '5 years',
      'rating': '4.8',
      'description': 'Expert in residential plumbing, pipe repair, and maintenance.'
    },
    {
      'name': 'Mikes',
      'experience': '3 years',
      'rating': '4.5',
      'description': 'Specializes in leak detection and faucet installation.'
    },
    {
      'name': 'Anna Smith',
      'experience': '4 years',
      'rating': '4.6',
      'description': 'Experienced in bathroom and kitchen plumbing services.'
    },
    {
      'name': 'John Doe',
      'experience': '2 years',
      'rating': '4.4',
      'description': 'Reliable plumber for small home repair jobs.'
    },
    {
      'name': 'Ali Hassan',
      'experience': '6 years',
      'rating': '4.9',
      'description': 'Skilled in pipe replacement and water system maintenance.'
    },
    {
      'name': 'Sara Ali',
      'experience': '3 years',
      'rating': '4.3',
      'description': 'Professional plumber for household plumbing issues.'
    },
    {
      'name': 'Ahmed Khan',
      'experience': '5 years',
      'rating': '4.7',
      'description': 'Provides emergency plumbing services and installations.'
    },
  ],
  'Electrician': [
    {
      'name': 'Ali Raza',
      'experience': '4 years',
      'rating': '4.7',
      'description': 'Experienced in home wiring, repair, and maintenance.'
    },
    {
      'name': 'Sara Khan',
      'experience': '3 years',
      'rating': '4.6',
      'description': 'Skilled in electrical panel upgrades and light installations.'
    },
    {
      'name': 'Hamza Ali',
      'experience': '5 years',
      'rating': '4.8',
      'description': 'Specializes in residential and commercial electrical work.'
    },
    {
      'name': 'Bilal Ahmed',
      'experience': '2 years',
      'rating': '4.5',
      'description': 'Handles small electrical repairs efficiently.'
    },
    {
      'name': 'Hina Saleem',
      'experience': '6 years',
      'rating': '4.9',
      'description': 'Expert in wiring, circuits, and safety inspections.'
    },
    {
      'name': 'Omar Farooq',
      'experience': '3 years',
      'rating': '4.4',
      'description': 'Reliable electrician for home and office setups.'
    },
    {
      'name': 'Zain Abbas',
      'experience': '4 years',
      'rating': '4.6',
      'description': 'Experienced in light installation and electrical troubleshooting.'
    },
  ],
  'Cleaner': [
    {
      'name': 'Adeel Khan',
      'experience': '2 years',
      'rating': '4.7',
      'description': 'Provides thorough home and office cleaning services.'
    },
    {
      'name': 'Nadia Ali',
      'experience': '3 years',
      'rating': '4.6',
      'description': 'Specialist in deep cleaning and sanitation.'
    },
    {
      'name': 'Hassan Rafi',
      'experience': '4 years',
      'rating': '4.5',
      'description': 'Experienced in professional housekeeping and maintenance.'
    },
    {
      'name': 'Sana Tariq',
      'experience': '5 years',
      'rating': '4.8',
      'description': 'Skilled in cleaning offices, homes, and commercial areas.'
    },
    {
      'name': 'Fahad Iqbal',
      'experience': '3 years',
      'rating': '4.4',
      'description': 'Efficient in daily and deep cleaning tasks.'
    },
    {
      'name': 'Maria Khan',
      'experience': '2 years',
      'rating': '4.3',
      'description': 'Provides eco-friendly and safe cleaning solutions.'
    },
    {
      'name': 'Rashid Ahmed',
      'experience': '6 years',
      'rating': '4.9',
      'description': 'Reliable cleaner with attention to detail.'
    },
  ],
   'Painter': [
    {'name': 'Rashid Mehmood', 'experience': '4 years', 'rating': '4.6', 'description': 'Professional house and office painter.'},
    {'name': 'Ali Saeed', 'experience': '5 years', 'rating': '4.8', 'description': 'Specializes in interior and exterior painting.'},
    {'name': 'Sara Iqbal', 'experience': '3 years', 'rating': '4.5', 'description': 'Experienced in decorative and wall painting.'},
    {'name': 'Hamza Rauf', 'experience': '4 years', 'rating': '4.6', 'description': 'Provides high-quality painting services.'},
    {'name': 'Nadia Khan', 'experience': '2 years', 'rating': '4.3', 'description': 'Affordable and efficient painter for homes.'},
    {'name': 'Ahmed Raza', 'experience': '5 years', 'rating': '4.7', 'description': 'Expert in furniture and wall finishing.'},
    {'name': 'Zainab Ali', 'experience': '3 years', 'rating': '4.4', 'description': 'Specializes in residential painting jobs.'},
  ],

  'Mason': [
    {'name': 'Hamza Khan', 'experience': '6 years', 'rating': '4.5', 'description': 'Expert in brickwork and structural repairs.'},
    {'name': 'Ali Ahmed', 'experience': '4 years', 'rating': '4.6', 'description': 'Experienced in home construction and masonry.'},
    {'name': 'Sara Malik', 'experience': '3 years', 'rating': '4.4', 'description': 'Skilled in wall building and repair.'},
    {'name': 'Ahmed Rafi', 'experience': '5 years', 'rating': '4.7', 'description': 'Reliable mason for all types of construction work.'},
    {'name': 'Bilal Khan', 'experience': '2 years', 'rating': '4.3', 'description': 'Provides quality masonry repair services.'},
    {'name': 'Hina Iqbal', 'experience': '3 years', 'rating': '4.5', 'description': 'Skilled in bricklaying and plastering.'},
    {'name': 'Omar Farooq', 'experience': '4 years', 'rating': '4.6', 'description': 'Expert in home renovations and masonry.'},
  ],

  'IT Support': [
    {'name': 'Zain Ahmed', 'experience': '3 years', 'rating': '4.9', 'description': 'Handles computer setup, troubleshooting, and maintenance.'},
    {'name': 'Sara Khan', 'experience': '4 years', 'rating': '4.8', 'description': 'Specialist in network and software support.'},
    {'name': 'Ali Raza', 'experience': '5 years', 'rating': '4.7', 'description': 'Expert in hardware repairs and IT solutions.'},
    {'name': 'Hassan Tariq', 'experience': '2 years', 'rating': '4.4', 'description': 'Provides professional tech support for offices.'},
    {'name': 'Ayesha Iqbal', 'experience': '3 years', 'rating': '4.6', 'description': 'Specializes in IT troubleshooting and maintenance.'},
    {'name': 'Omar Farooq', 'experience': '4 years', 'rating': '4.5', 'description': 'Reliable IT support for small businesses.'},
    {'name': 'Maria Khan', 'experience': '2 years', 'rating': '4.3', 'description': 'Skilled in software installation and updates.'},
  ],

  'Carpenter': [
    {'name': 'Ahmad Ali', 'experience': '5 years', 'rating': '4.7', 'description': 'Skilled in furniture making and repair.'},
    {'name': 'Sara Rafi', 'experience': '3 years', 'rating': '4.5', 'description': 'Specializes in wooden structures and cabinets.'},
    {'name': 'Hamza Khan', 'experience': '4 years', 'rating': '4.6', 'description': 'Experienced carpenter for home projects.'},
    {'name': 'Ali Raza', 'experience': '6 years', 'rating': '4.8', 'description': 'Expert in custom furniture design and installation.'},
    {'name': 'Nadia Ali', 'experience': '2 years', 'rating': '4.3', 'description': 'Provides small carpentry repairs and assembly.'},
    {'name': 'Bilal Ahmed', 'experience': '3 years', 'rating': '4.4', 'description': 'Skilled in home furniture and wooden fixtures.'},
    {'name': 'Zainab Malik', 'experience': '5 years', 'rating': '4.7', 'description': 'Reliable carpenter with precision work.'},
  ],

  'Pest Control': [
    {'name': 'Fahad Khan', 'experience': '4 years', 'rating': '4.6', 'description': 'Specialist in termite and rodent control.'},
    {'name': 'Sara Ali', 'experience': '3 years', 'rating': '4.5', 'description': 'Provides safe and effective pest control services.'},
    {'name': 'Ali Raza', 'experience': '5 years', 'rating': '4.7', 'description': 'Experienced in home and office pest management.'},
    {'name': 'Hassan Tariq', 'experience': '2 years', 'rating': '4.4', 'description': 'Skilled in eco-friendly pest control solutions.'},
    {'name': 'Ayesha Khan', 'experience': '3 years', 'rating': '4.6', 'description': 'Professional in insect and rodent removal.'},
    {'name': 'Bilal Ahmed', 'experience': '4 years', 'rating': '4.5', 'description': 'Reliable and prompt pest control services.'},
    {'name': 'Maria Iqbal', 'experience': '2 years', 'rating': '4.3', 'description': 'Skilled in general pest management for homes.'},
  ],
  // You can continue the same way for Painter, Mason, IT Support, Carpenter, Pest Control
};

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning'; 
    if (hour < 17) return 'Good Afternoon'; 
    return 'Good Evening'; 
  }

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.displayName ?? user.email?.split('@')[0] ?? 'User';
    }
    return 'User';
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((c) =>
              c['label'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      filteredCategories = categories;
    });
  }

  // Main Screens for Navbar
  List<Widget> get _screens => [
        _buildDashboardContent(),
        const BookingHistoryScreen(),
        const ChatScreen(),
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    final greeting = _getGreeting();

    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userName = snapshot.data ?? 'User';

        return RefreshIndicator(
          onRefresh: _refreshCategories,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Card
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                  )),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade400, Colors.teal.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$greeting, $userName!',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _filterCategories,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Support Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.grey.shade300,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade50,
                      child: const Icon(Icons.support_agent, color: Colors.teal),
                    ),
                    title: const Text(
                      "Need Help?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: const Text("Get support from our team"),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SupportScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Categories Grid
                const Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final animationIntervalStart = 0.5 + (index * 0.05);
                    // Get first worker image for the category
                    final imageUrl = (workersByCategory[category['label']] != null &&
                            workersByCategory[category['label']]!.isNotEmpty &&
                            workersByCategory[category['label']]![0]['image'] != null)
                        ? workersByCategory[category['label']]![0]['image']
                        : null;

                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: Interval(animationIntervalStart, 1.0,
                            curve: Curves.easeIn),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _controller,
                          curve: Interval(animationIntervalStart, 1.0,
                              curve: Curves.easeOut),
                        )),
                        child: CategoryTile(
                          icon: category['icon']!,
                          label: category['label']!,
                          imageUrl: imageUrl,
                          onTap: () {
                            final workersList = (workersByCategory[category['label']] ?? [])
                                .map((w) => w.map((k, v) => MapEntry(k, v.toString())))
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkerListScreen(
                                  category: category['label']!,
                                  workers: workersList,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// CategoryTile
class CategoryTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final String? imageUrl;

  const CategoryTile({
    this.icon,
    required this.label,
    required this.onTap,
    this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        shadowColor: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Network Image or Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.shade50,
                ),
                child: imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(icon ?? Icons.help_outline,
                                  size: 40, color: const Color(0xFF00695C)),
                        ),
                      )
                    : Icon(icon ?? Icons.help_outline,
                        size: 40, color: const Color(0xFF00695C)),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
