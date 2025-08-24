import 'package:flutter/material.dart';
import 'booking_screen.dart'; // Import your booking screen

class WorkerListScreen extends StatefulWidget {
  final String category;
  final List<Map<String, String>> workers;

  const WorkerListScreen({
    super.key,
    required this.category,
    required this.workers,
  });

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerList = widget.workers.isNotEmpty ? widget.workers : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Workers'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: workerList.isEmpty
          ? const Center(
              child: Text(
                'No workers available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workerList.length,
              itemBuilder: (context, index) {
                final worker = workerList[index];

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500 + index * 100),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.teal.shade50,
                                child: worker['image'] != null
                                    ? ClipOval(
                                        child: Image.network(
                                          worker['image']!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Text(
                                              worker['name'] != null
                                                  ? worker['name']![0]
                                                  : '',
                                              style: const TextStyle(
                                                  fontSize: 24, color: Colors.teal),
                                            );
                                          },
                                        ),
                                      )
                                    : Text(
                                        worker['name'] != null
                                            ? worker['name']![0]
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.teal),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      worker['name'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Experience: ${worker['experience'] ?? ''}'),
                                    const SizedBox(height: 2),
                                    Text('Rating: ${worker['rating'] ?? ''}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008080),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
