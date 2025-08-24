import 'package:flutter/material.dart';
import 'package:my_final_project/services/firestore_services.dart';

class FindProviderScreen extends StatefulWidget {
  final String category; // Example: "Plumber", "Electrician"
  const FindProviderScreen({super.key, required this.category});

  @override
  State<FindProviderScreen> createState() => _FindProviderScreenState();
}

class _FindProviderScreenState extends State<FindProviderScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Map<String, dynamic>>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = _firestoreService.getProvidersByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find ${widget.category} Providers"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No providers found"));
          }

          final providers = snapshot.data!;
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(provider["name"] ?? "Unknown"),
                  subtitle: Text(
                      "${provider["serviceCategory"]} • ${provider["location"]}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // 👇 Yahan BookingScreen pe navigate kara sakti ho
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => BookingScreen(provider: provider),
                      // ));
                    },
                    child: const Text("Book"),
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
