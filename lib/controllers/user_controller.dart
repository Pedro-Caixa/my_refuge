import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/registration_data.dart';
import '../models/check_in.dart';

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
    try {
      print("Inicializando UserController e ouvindo mudanças de autenticação");
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          print(
              "Usuário autenticado: ${user.uid}, anônimo: ${user.isAnonymous}");
          _loadCurrentUser(user.uid);
        } else {
          print("Nenhum usuário autenticado");
          _currentUser = null;
          notifyListeners();
        }
      }, onError: (error) {
        print("Erro no listener de auth: $error");
        _setError("Erro ao monitorar estado de autenticação: $error");
      });
    } catch (e) {
      print("Erro ao inicializar UserController: $e");
      _setError("Erro ao inicializar controlador: $e");
    }
  }

  Future<void> _loadCurrentUser(String uid) async {
    try {
      _setLoading(true);
      print("Carregando dados do usuário: $uid");

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        print("Documento do usuário encontrado no Firestore");
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _currentUser = RegistrationData.fromMap(data, uid);
        print("Dados do usuário carregados com sucesso");

        // Verificar e resetar streak se necessário
        await checkAndResetStreak();
      } else {
        print("Documento do usuário não existe no Firestore");
        // Usuário existe no Auth mas não no Firestore
        // Vamos criar um perfil básico
        final User? authUser = _auth.currentUser;
        if (authUser != null && authUser.isAnonymous) {
          print("Criando perfil básico para usuário anônimo");
          _currentUser = RegistrationData()
            ..uid = uid
            ..isAnonymous = true
            ..userType = "Estudante"; // Tipo padrão
        }
      }
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
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

      // Use toMap() method and add createdAt field
      Map<String, dynamic> userData = registrationData.toMap();
      userData['createdAt'] = FieldValue.serverTimestamp();
      userData['isAnonymous'] = false;
      userData['dailyStreak'] = 0;

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

      // Use toMap() method and add updatedAt field
      Map<String, dynamic> updateData = registrationData.toMap();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      // Remove email field as we don't want to update it this way
      updateData.remove('email');

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

  /// Atualiza o perfil do usuário (para usuários já registrados)
  Future<bool> updateUserProfile(RegistrationData registrationData) async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user == null) {
        _setError('Usuário não autenticado');
        return false;
      }

      if (_currentUser == null) {
        _setError('Dados do usuário não carregados');
        return false;
      }

      // Preparar dados para atualização
      Map<String, dynamic> updateData = {
        'name': registrationData.name,
        'userType': registrationData.userType,
        'ageRange': registrationData.ageRange,
        'profession': registrationData.profession,
        'livesAlone': registrationData.livesAlone,
        'gender': registrationData.gender,
        'availableTime': registrationData.availableTime,
        'hobbies': registrationData.hobbies,
        'receivesNotifications': registrationData.receivesNotifications,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remover campos vazios/nulos
      updateData.removeWhere((key, value) => value == null || value == '');

      // Atualizar no Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Recarregar dados do usuário
      await _loadCurrentUser(user.uid);

      return true;
    } catch (e) {
      _setError('Erro ao atualizar perfil: $e');
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

  /// Cria um usuário anônimo com o tipo especificado (Estudante/Colaborador)
  /// Opcionalmente, inclui profissão e faixa etária
  Future<bool> signInAnonymously(String userType,
      {String? profession, String? ageRange}) async {
    try {
      _setLoading(true);
      _clearError();

      print("Verificando estado do Firebase Auth...");

      print("Tentando autenticar anonimamente...");

      // Autenticar anonimamente com o Firebase
      print("Chamando signInAnonymously()...");
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print("Autenticação anônima bem-sucedida: ${userCredential.user?.uid}");

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Criar um objeto RegistrationData para o usuário anônimo
        final userData = RegistrationData()
          ..uid = uid
          ..isAnonymous = true
          ..userType = userType
          ..dailyStreak = 0;

        // Adicionar campos opcionais se fornecidos
        if (profession != null && profession.isNotEmpty) {
          userData.profession = profession;
        }

        if (ageRange != null && ageRange.isNotEmpty) {
          userData.ageRange = ageRange;
        }

        try {
          // Salvar dados no Firestore
          print("Salvando dados no Firestore para o usuário $uid");
          await _firestore.collection('users').doc(uid).set(userData.toMap());

          // Atualizar dados do usuário atual
          _currentUser = userData;
          notifyListeners();

          return true;
        } catch (firestoreError) {
          print("Erro ao salvar no Firestore: $firestoreError");
          _setError('Erro ao salvar dados do usuário: $firestoreError');
          // Mesmo com erro no Firestore, o usuário foi criado no Auth
          // então podemos considerá-lo logado com informações básicas
          _currentUser = userData;
          notifyListeners();
          return true;
        }
      } else {
        _setError('Falha ao criar usuário anônimo: usuário nulo');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      if (e.code == 'configuration-not-found') {
        _setError(
            'Erro de configuração do Firebase. Verifique sua conexão com a internet e tente novamente.');
      } else {
        _handleAuthError(e);
      }
      return false;
    } catch (e) {
      print("Erro desconhecido ao criar usuário anônimo: $e");
      _setError('Erro ao criar usuário anônimo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Incrementa a sequência diária (streak) do usuário
  Future<bool> incrementDailyStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null || _currentUser == null) {
        _setError('Usuário não autenticado');
        return false;
      }

      int newStreak = (_currentUser!.dailyStreak + 1);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'dailyStreak': newStreak});

      _currentUser!.dailyStreak = newStreak;
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Erro ao atualizar streak diária: $e');
      return false;
    }
  }

  /// Completa o perfil de um usuário anônimo com todas as informações
  /// Converte o usuário anônimo em uma conta permanente
  Future<bool> completeAnonymousProfile(RegistrationData data) async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        _setError('Operação permitida apenas para usuários anônimos');
        return false;
      }

      if (!_isValidEmail(data.email)) {
        _setError('Email inválido!');
        return false;
      }

      if (!_isValidPassword(data.password)) {
        _setError('Senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      if (data.password != data.confirmPassword) {
        _setError('As senhas não coincidem!');
        return false;
      }

      // Vincular conta de email/senha ao usuário anônimo atual
      AuthCredential credential = EmailAuthProvider.credential(
          email: data.email, password: data.password);
      await user.linkWithCredential(credential);

      // Preparar dados completos para atualizar no Firestore
      Map<String, dynamic> updateData = data.toMap();
      updateData['isAnonymous'] = false;
      updateData['convertedAt'] = FieldValue.serverTimestamp();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      // Atualizar todos os dados do usuário no Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Recarregar dados do usuário
      await _loadCurrentUser(user.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _setError('Este email já está cadastrado!');
      } else if (e.code == 'credential-already-in-use') {
        _setError('Estas credenciais já estão em uso!');
      } else {
        _handleAuthError(e);
      }
      return false;
    } catch (e) {
      _setError('Erro ao completar perfil: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verifica se o usuário atual é anônimo
  bool isAnonymousUser() {
    return _auth.currentUser?.isAnonymous ?? false;
  }

  /// Converte um usuário anônimo em uma conta permanente com email/senha
  Future<bool> convertAnonymousUser(
      String email, String password, String confirmPassword) async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        _setError('Operação permitida apenas para usuários anônimos');
        return false;
      }

      if (!_isValidEmail(email)) {
        _setError('Email inválido!');
        return false;
      }

      if (!_isValidPassword(password)) {
        _setError('Senha deve ter pelo menos 6 caracteres!');
        return false;
      }

      if (password != confirmPassword) {
        _setError('As senhas não coincidem!');
        return false;
      }

      // Vincular conta de email/senha ao usuário anônimo atual
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.linkWithCredential(credential);

      // Atualizar dados do usuário no Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
        'isAnonymous': false,
        'convertedAt': FieldValue.serverTimestamp(),
      });

      // Recarregar dados do usuário
      await _loadCurrentUser(user.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('Erro ao converter usuário anônimo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
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

  Future<bool> saveCheckIn(int mood, {String? note}) async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user == null) {
        _setError('Usuário não autenticado');
        return false;
      }

      final checkIn = CheckIn(
        id: '',
        userId: user.uid,
        date: DateTime.now(),
        mood: mood,
        note: note,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('checkins')
          .add(checkIn.toMap());

      await _updateStreak(user.uid);

      return true;
    } catch (e) {
      _setError('Erro ao salvar check-in: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<CheckIn>> getCheckIns({int limit = 30}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('checkins')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => CheckIn.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Erro ao buscar check-ins: $e');
      return [];
    }
  }

  Future<bool> hasCheckedInToday() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('checkins')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar check-in do dia: $e');
      return false;
    }
  }

  Future<void> _updateStreak(String uid) async {
    try {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final startOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);
      final endOfYesterday = startOfYesterday.add(const Duration(days: 1));

      final yesterdayCheckIn = await _firestore
          .collection('users')
          .doc(uid)
          .collection('checkins')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYesterday))
          .where('date', isLessThan: Timestamp.fromDate(endOfYesterday))
          .get();

      int newStreak = yesterdayCheckIn.docs.isNotEmpty
          ? (_currentUser?.dailyStreak ?? 0) + 1
          : 1;

      await _firestore.collection('users').doc(uid).update({
        'dailyStreak': newStreak,
      });

      if (_currentUser != null) {
        _currentUser!.dailyStreak = newStreak;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar streak: $e');
    }
  }

  Future<void> checkAndResetStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null || _currentUser == null) return;

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final startOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);
      final endOfYesterday = startOfYesterday.add(const Duration(days: 1));

      final yesterdayCheckIn = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('checkins')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYesterday))
          .where('date', isLessThan: Timestamp.fromDate(endOfYesterday))
          .get();

      if (yesterdayCheckIn.docs.isEmpty && (_currentUser!.dailyStreak > 1)) {
        await _firestore.collection('users').doc(user.uid).update({
          'dailyStreak': 1,
        });
        _currentUser!.dailyStreak = 1;
        notifyListeners();
        print('Streak resetado para 1 devido à falta de check-in ontem');
      }
    } catch (e) {
      print('Erro ao verificar/resetar streak: $e');
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
