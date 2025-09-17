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

  // Getters
  List<UserModel> get users => _users;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Construtor
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

      // Validações
      if (!_isValidEmail(user.email ?? '')) {
        _setError('Email inválido!');
        return false;
      }

      if (!_isValidPassword(senha)) {
        _setError('Senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      // Criar usuário no Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: user.email!, password: senha);

      // ✅ SEGURO: Criar usuário SEM a senha para o Firestore
      final newUser = UserModel(
        id: userCredential.user?.uid,
        email: user.email,
        // senha: REMOVIDO - nunca salvar senha no Firestore
        tipoUsuario: user.tipoUsuario,
        nome: user.nome,
        faixaEtaria: user.faixaEtaria,
        profissao: user.profissao,
        moraSozinho: user.moraSozinho,
        sexo: user.sexo,
        tempoDisponivel: user.tempoDisponivel,
        hobbies: user.hobbies,
        createdAt: Timestamp.fromDate(DateTime.now()), // Adicionar timestamp
      );

      // Salvar no Firestore (sem senha)
      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
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

      // Validações básicas
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

      // Adicionar timestamp de atualização
      final updatedUser = user.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection('users')
          .doc(user.id)
          .update(updatedUser.toMap());

      _currentUser = updatedUser;

      return true;
    } catch (e) {
      _setError('Erro ao atualizar usuário: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ✅ Função para alterar senha
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

      // Reautenticar usuário
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Alterar senha
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

  // ✅ Validações
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  // ✅ Tratamento centralizado de erros
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
