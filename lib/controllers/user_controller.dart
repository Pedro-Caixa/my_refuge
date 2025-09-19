import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';

class UserController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  UserModel? get currentUser => _currentUser;
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
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _setError('Erro ao carregar dados do usuário: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerUser(UserModel user, String senha) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_isValidEmail(user.email ?? '')) {
        _setError('Email inválido!');
        return false;
      }

      if (!_isValidPassword(senha)) {
        _setError('Senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: user.email!, password: senha);

      final newUser = UserModel(
        id: userCredential.user?.uid,
        email: user.email,

        tipoUsuario: user.tipoUsuario,
        nome: user.nome,
        faixaEtaria: user.faixaEtaria,
        profissao: user.profissao,
        moraSozinho: user.moraSozinho,
        sexo: user.sexo,
        tempoDisponivel: user.tempoDisponivel,
        hobbies: user.hobbies,
      );

      Map<String, dynamic> userData = newUser.toMap();
      userData.remove('senha');
      userData['createdAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(newUser.id).set(userData);
      _currentUser = newUser;

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

  Future<bool> updateUser(UserModel user) async {
    try {
      _setLoading(true);
      _clearError();

      if (user.id == null) {
        _setError('ID do usuário não encontrado');
        return false;
      }

      Map<String, dynamic> updateData = user.toMap();
      updateData.remove('senha');
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.id).update(updateData);

      await _loadCurrentUser(user.id!);

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
