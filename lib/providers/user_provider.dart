import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_travels_3/models/user_model.dart';
import 'package:safe_travels_3/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    print('Initializing UserProvider');
    _authService.authStateChanges.listen((User? firebaseUser) async {
      _isLoading = true;
      notifyListeners();

      if (firebaseUser != null) {
        print('User is logged in: ${firebaseUser.uid}');
        // User is logged in, get user data from Firestore
        _user = await _authService.getUserData();
      } else {
        print('User is logged out');
        // User is logged out
        _user = null;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.signInWithEmailAndPassword(email, password);
      
      // User data will be updated via the authStateChanges listener
    } catch (e) {
      print('Login error in provider: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password, String username, String ageGroup) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.registerWithEmailAndPassword(email, password, username, ageGroup);
      
      // User data will be updated via the authStateChanges listener
    } catch (e) {
      print('Registration error in provider: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.signOut();
      
      // User data will be updated via the authStateChanges listener
    } catch (e) {
      print('Logout error in provider: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}