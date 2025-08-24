import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  String formatDateTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading bookings"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text("No bookings found."));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;

              String serviceName =
                  (data['serviceName'] ?? '').toString().trim().isEmpty
                      ? 'No Service'
                      : data['serviceName'];

              String customerName =
                  (data['customerName'] ?? '').toString().trim().isEmpty
                      ? 'Unknown Customer'
                      : data['customerName'];

              String address =
                  (data['address'] ?? '').toString().trim().isEmpty
                      ? 'No Address Provided'
                      : data['address'];

              String status = (data['status'] ?? 'Pending').toString();

              String dateTime = '';
              if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
                dateTime = formatDateTime(data['createdAt'] as Timestamp);
              }

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  title: Text(
                    serviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("👤 Customer: $customerName"),
                      Text("📍 Address: $address"),
                      if (dateTime.isNotEmpty) Text("📅 Date: $dateTime"),
                      const SizedBox(height: 4),
                      Text(
                        "📌 Status: $status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status.trim().toLowerCase() == "completed"
                              ? Colors.green
                              : status.trim().toLowerCase() == "cancelled"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
