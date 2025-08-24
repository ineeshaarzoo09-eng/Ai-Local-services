import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save booking in Firestore
  Future<void> saveBooking({
    required String customerId,
    required String customerName,
    required String address,
    required String bookingDate,
    required String bookingTime,
    required String serviceName,
    String? notes,
    String? providerName,
    String? serviceId,
  }) async {
    await _db.collection('bookings').add({
      'userId': customerId,
      'customerName': customerName,
      'address': address,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'serviceName': serviceName,
      'notes': notes ?? '',
      'providerName': providerName ?? '',
      'serviceId': serviceId ?? '',
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get providers by category
  Future<List<Map<String, dynamic>>> getProvidersByCategory(String category) async {
    final snapshot = await _db
        .collection("users")
        .where("role", isEqualTo: "provider")
        .where("serviceCategory", isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
