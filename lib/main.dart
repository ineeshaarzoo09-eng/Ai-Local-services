import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_final_project/fine_provider_screen.dart';
import 'package:my_final_project/change_password.dart';
import 'package:my_final_project/chatbot_screen.dart';
import 'package:my_final_project/edit_profile_screen.dart';
import 'package:my_final_project/login_screen.dart';
import 'package:my_final_project/customer_dashboard_screen.dart';
import 'package:my_final_project/notification_screen.dart';
import 'package:my_final_project/onbaording_screen.dart';
import 'package:my_final_project/privacy_policy_screen.dart';
import 'package:my_final_project/signup_screen.dart';
import 'package:my_final_project/splash_screen.dart';
import 'models/firebase_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase Initialized Successfully!");
  } catch (e) {
    print("❌ Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Local Services',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFE0F2F1),
      ),
      home: const SplashScreen(), // <-- SplashScreen is now the first screen
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const CustomerDashboard(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/privacy-policy-screen': (context) => const PrivacyScreen(),
        '/edit-profile-screen': (context) => const EditProfileScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/chatbot': (context) => const ChatScreen(),
        '/fineProvider': (context) => const FindProviderScreen(category: 'plumber'),
      },
    );
  }
}
