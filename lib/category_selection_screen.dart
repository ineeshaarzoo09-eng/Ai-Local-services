import 'package:flutter/material.dart';
import 'package:my_final_project/worker_list_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  CategorySelectionScreen({super.key});

  final Map<String, List<Map<String, dynamic>>> workersByCategory = {
    'Plumber': [
      {
        'name': 'Usman Electrician',
        'experience': '5 years',
        'rating': '4.8',
        'reviews': 120,
        'description': 'Certified plumber with residential & commercial experience.'
      },
    ],
    'Electrician': [
      {
        'name': 'Ali Raza',
        'experience': '4 years',
        'rating': '4.7',
        'reviews': 80,
        'description': 'Expert in wiring and electrical repairs.'
      },
    ],
    'Mason': [
      {
        'name': 'Hamza Khan',
        'experience': '6 years',
        'rating': '4.5',
        'reviews': 110,
        'description': 'Specialist in concrete and foundation work.'
      },
    ],
    'Painter': [
      {
        'name': 'Rashid Mehmood',
        'experience': '4 years',
        'rating': '4.6',
        'reviews': 70,
        'description': 'Interior and exterior painting expert.'
      },
    ],
    'IT Support': [
      {
        'name': 'Zain Ahmed',
        'experience': '3 years',
        'rating': '4.9',
        'reviews': 75,
        'description': 'PC troubleshooting & network setup.'
      },
    ],
    'Cleaner': [
      {
        'name': 'Adeel Khan',
        'experience': '2 years',
        'rating': '4.7',
        'reviews': 60,
        'description': 'Deep kitchen and bathroom cleaning.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Worker Category'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: workersByCategory.keys.map((category) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF008080),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkerListScreen(
                      category: category, workers: [], // Just pass the string
                      //workers: workersByCategory[category] ?? [], // Safe fallback
                    ),
                  ),
                );
              },
              child: Text(
                'View $category Workers',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
