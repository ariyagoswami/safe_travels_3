import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_travels_3/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('Attempting to sign in user: $email');
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in successful for user: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('Sign in failed: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String username, String ageGroup) async {
    try {
      print('Attempting to register user: $email');
      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      await _createUserDocument(userCredential.user!.uid, username, email, ageGroup);
      
      print('Registration successful for user: ${userCredential.user?.uid}');
      return userCredential;
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(String uid, String username, String email, String ageGroup) async {
    try {
      print('Creating user document for: $uid');
      final userModel = UserModel(
        id: uid,
        username: username,
        email: email,
        ageGroup: ageGroup,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('users').doc(uid).set(userModel.toJson());
      print('User document created successfully');
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print('Signing out user');
      await _auth.signOut();
      print('Sign out successful');
    } catch (e) {
      print('Sign out failed: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData() async {
    try {
      if (currentUser == null) {
        print('No current user found');
        return null;
      }
      
      print('Fetching user data for: ${currentUser!.uid}');
      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        print('User data found');
        return UserModel.fromJson(doc.data()!);
      }
      print('User document not found');
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}