import 'package:flutter/material.dart';
import 'dart:developer';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInUpForm extends StatefulWidget {
  // The callback is required, ensure it's used correctly where sign-in/up succeeds
  const SignInUpForm({super.key, required Null Function() onSignInUpSuccess});

  @override
  SignInUpFormState createState() => SignInUpFormState();
}

class SignInUpFormState extends State<SignInUpForm> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _signUpConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_signInFormKey.currentState!.validate()) {
      // Process sign in
      log('Signing in with email: ${_signInEmailController.text} and password: ${_signInPasswordController.text}', name: 'SignInUpForm');

      // TODO: Implement actual authentication logic here.
      // After successful authentication, determine the user type (farmer or consumer).
      // For demonstration, let's assume a variable `userType` holds the user's role.
      String userType = 'farmer'; // Replace with actual logic to get user type

      if (userType == 'farmer') {
        Navigator.pushReplacementNamed(context, '/farmersDashboard'); // Replace with your actual route name
      } else if (userType == 'consumer') {
        Navigator.pushReplacementNamed(context, '/consumerDashboard'); // Replace with your actual route name
      }
    }
  }
  void _signUp() {
    if (_signUpFormKey.currentState!.validate()) {
      // Process sign up
      AuthService().signUpWithEmailAndPassword(
        _signUpEmailController.text,
        _signUpPasswordController.text,
      ).then((userCredential) async {
        if (userCredential != null && userCredential.user != null) {
          // User successfully signed up
          log('User signed up: ${userCredential.user!.uid}', name: 'SignInUpForm');
          // Store user role in Firestore
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'role': 'farmer', // Placeholder: Determine role during sign-up
          });
          // TODO: Navigate to the appropriate dashboard based on role after sign-up
        }
      }).catchError((error) {
        log('Sign up error: $error', name: 'SignInUpForm');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In/Sign Up'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSignInForm(),
          _buildSignUpForm(),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _signInEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _signInPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<bool>(
              future: AuthService().canAuthenticateWithBiometrics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
                  // If biometrics is not available or not enabled, just show the sign-in button
                  return ElevatedButton(
                    onPressed: _signIn,
                    child: const Text('Sign In'),
                  );
                }

                // If biometrics is available and enabled, show both button and icon
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _signIn,
                        child: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.fingerprint), // Or Icons.face
                      onPressed: () async {
                         bool authenticated = await AuthService().authenticateWithBiometrics();
                         if (authenticated) {
                           // TODO: Implement logic to retrieve stored credentials and sign in the user
                         }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _signUpEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _signUpPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _signUpConfirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _signUpPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.
