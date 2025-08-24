import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String userName = '';
  String userEmail = '';
  String? profileImageUrl;
  File? profileImage;
  bool notificationsEnabled = true;

  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchUserData(); // Fetch user info from Firestore
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimations = List.generate(
      6,
      (index) => Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.15, 1, curve: Curves.easeOut),
        ),
      ),
    );

    _fadeAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.15, 1, curve: Curves.easeIn),
        ),
      ),
    );

    _controller.forward();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!mounted) return;

        setState(() {
          userEmail = user.email ?? '';
          if (doc.exists) {
            userName = doc.data()?['name'] ?? '';
            profileImageUrl = doc.data()?['profileImageUrl'];
          }
        });
      } catch (e) {
        debugPrint("❌ Error fetching user data: $e");
      }
    }
  }

  Future<void> pickProfileImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      File pickedImage = File(result.files.single.path!);

      setState(() {
        profileImage = pickedImage;
      });

      try {
        String fileName = 'profile_${FirebaseAuth.instance.currentUser!.uid}.png';
        Reference ref =
            FirebaseStorage.instance.ref().child('profile_images/$fileName');
        await ref.putFile(pickedImage);
        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profileImageUrl': downloadUrl});

        if (!mounted) return;

        setState(() {
          profileImageUrl = downloadUrl;
        });
      } catch (e) {
        debugPrint("❌ Error uploading profile image: $e");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedTile(int index, Widget child) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(opacity: _fadeAnimations[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
              onTap: pickProfileImage,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.teal,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : (profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null),
                child: (profileImage == null && profileImageUrl == null)
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName.isNotEmpty
                  ? userName
                  : (currentUser?.displayName ?? "Username"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              userEmail.isNotEmpty ? userEmail : (currentUser?.email ?? "Email"),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1.2),

            // Menu Options
            _buildAnimatedTile(
              0,
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, '/edit-profile-screen'),
              ),
            ),
            _buildAnimatedTile(
              1,
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () =>
                    Navigator.pushNamed(context, '/change-password'),
              ),
            ),
            _buildAnimatedTile(
              2,
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ),
            ),
            _buildAnimatedTile(
              3,
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, '/language'),
              ),
            ),
            _buildAnimatedTile(
              4,
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, '/privacy-policy-screen'),
              ),
            ),
            _buildAnimatedTile(
              5,
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.red),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
