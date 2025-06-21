import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

const String _biometricPreferenceaKey = 'enableBiometric';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication errors
      if (e.code == 'weak-password') {
        log('The password provided is too weak.', name: 'AuthService');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.', name: 'AuthService');
      }
      // You can throw the exception or return null based on your error handling strategy
      rethrow;
    } catch (e) {
      // Handle other errors
      log(e.toString(), name: 'AuthService');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication errors
      if (e.code == 'user-not-found') {
        log('No user found for that email.', name: 'AuthService');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.', name: 'AuthService');
      }
      // You can throw the exception or return null based on your error handling strategy
      rethrow;
    } catch (e) {
      // Handle other errors
      log(e.toString(), name: 'AuthService');
      rethrow;
    }
  }

  // Method to get the current authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method to sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if biometric authentication is available
  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      log('Error checking biometric availability: $e', name: 'AuthService');
      return false;
    }
  }

  // Trigger biometric authentication prompt
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(localizedReason: 'Authenticate to access your account');
    } catch (e) {
      log('Error during biometric authentication: $e', name: 'AuthService');
      return false;
    }
  }

  // Save biometric preference
  Future<void> saveBiometricPreference(bool enable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricPreferenceaKey, enable);
  }

  // Get biometric preference
  Future<bool> getBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricPreferenceaKey) ?? false; // Default to false
  }

  // Secure storage for credentials
  final _secureStorage = const FlutterSecureStorage();
  final String _emailKey = 'email';
  final String _passwordKey = 'password';

  // Save credentials securely
  Future<void> saveCredentialsSecurely(String email, String password) async {
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  // Get stored credentials securely
  Future<Map<String, String?>> getStoredCredentials() async {
    String? email = await _secureStorage.read(key: _emailKey);
    String? password = await _secureStorage.read(key: _passwordKey);
    return {
      'email': email,
      'password': password,
    };
  }

  // Delete stored credentials
  Future<void> deleteStoredCredentials() async {
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _passwordKey);
  }
}
