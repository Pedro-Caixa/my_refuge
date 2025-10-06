import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/registration_data.dart';

class UserController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegistrationData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  RegistrationData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  UserController() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadCurrentUser(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadCurrentUser(String uid) async {
    try {
      _setLoading(true);
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _currentUser = RegistrationData()
          ..email = data['email'] ?? ''
          ..userType = data['userType'] ?? 'paciente'
          ..name = data['name'] ?? ''
          ..ageRange = data['ageRange'] ?? ''
          ..profession = data['profession'] ?? ''
          ..livesAlone = data['livesAlone'] ?? 'nao'
          ..gender = data['gender'] ?? 'masc'
          ..availableTime = data['availableTime'] ?? ''
          ..hobbies = data['hobbies'] ?? ''
          ..receivesNotifications = data['receivesNotifications'] ?? true;
      }
    } catch (e) {
      _setError('Erro ao carregar dados do usuário: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerUser(RegistrationData registrationData) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_isValidEmail(registrationData.email)) {
        _setError('Email inválido!');
        return false;
      }

      if (!_isValidPassword(registrationData.password)) {
        _setError('Senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      if (registrationData.password != registrationData.confirmPassword) {
        _setError('As senhas não coincidem!');
        return false;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: registrationData.email,
              password: registrationData.password);

      Map<String, dynamic> userData = {
        'email': registrationData.email,
        'userType': registrationData.userType,
        'name': registrationData.name,
        'ageRange': registrationData.ageRange,
        'profession': registrationData.profession,
        'livesAlone': registrationData.livesAlone,
        'gender': registrationData.gender,
        'availableTime': registrationData.availableTime,
        'hobbies': registrationData.hobbies,
        'receivesNotifications': registrationData.receivesNotifications,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userData);

      // Atualizar o usuário atual após o registro
      await _loadCurrentUser(userCredential.user!.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('Erro ao registrar usuário: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_isValidEmail(email)) {
        _setError('Email inválido!');
        return false;
      }

      if (senha.isEmpty) {
        _setError('Senha é obrigatória!');
        return false;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('Erro ao fazer login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUser(RegistrationData registrationData) async {
    try {
      _setLoading(true);
      _clearError();

      if (_auth.currentUser == null) {
        _setError('Usuário não autenticado');
        return false;
      }

      Map<String, dynamic> updateData = {
        'userType': registrationData.userType,
        'name': registrationData.name,
        'ageRange': registrationData.ageRange,
        'profession': registrationData.profession,
        'livesAlone': registrationData.livesAlone,
        'gender': registrationData.gender,
        'availableTime': registrationData.availableTime,
        'hobbies': registrationData.hobbies,
        'receivesNotifications': registrationData.receivesNotifications,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updateData);

      // Atualizar o usuário atual após a atualização
      await _loadCurrentUser(_auth.currentUser!.uid);

      return true;
    } catch (e) {
      _setError('Erro ao atualizar usuário: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user == null) {
        _setError('Usuário não autenticado');
        return false;
      }

      if (!_isValidPassword(newPassword)) {
        _setError('Nova senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('Erro ao alterar senha: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_isValidEmail(email)) {
        _setError('Email inválido!');
        return false;
      }

      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('Erro ao enviar email de recuperação: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _clearError();
    } catch (e) {
      _setError('Erro ao fazer logout: $e');
    }
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        _setError('Este email já está cadastrado!');
        break;
      case 'weak-password':
        _setError('Senha muito fraca!');
        break;
      case 'user-not-found':
      case 'wrong-password':
        _setError('Email ou senha incorretos!');
        break;
      case 'invalid-email':
        _setError('Email inválido!');
        break;
      case 'user-disabled':
        _setError('Conta desabilitada!');
        break;
      case 'too-many-requests':
        _setError('Muitas tentativas. Tente novamente mais tarde.');
        break;
      default:
        _setError('Erro: ${e.message}');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
