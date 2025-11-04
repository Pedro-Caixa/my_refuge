import 'package:flutter/foundation.dart';

class RegistrationData extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _userType = '';
  String _name = '';
  String _ageRange = '';
  String _profession = '';
  String _livesAlone = 'nao';
  String _gender = 'masc';
  String _availableTime = '';
  String _hobbies = '';
  bool _receivesNotifications = true;
  int _dailyStreak = 0;
  bool _isAnonymous = false;
  String _uid = '';

  // Getters e Setters para todos os campos
  String get email => _email;
  set email(String value) {
    if (_email != value) {
      _email = value;
      notifyListeners();
    }
  }

  String get password => _password;
  set password(String value) {
    if (_password != value) {
      _password = value;
      notifyListeners();
    }
  }

  String get confirmPassword => _confirmPassword;
  set confirmPassword(String value) {
    if (_confirmPassword != value) {
      _confirmPassword = value;
      notifyListeners();
    }
  }

  String get userType => _userType;
  set userType(String value) {
    if (_userType != value) {
      _userType = value;
      notifyListeners();
    }
  }

  String get name => _name;
  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  String get ageRange => _ageRange;
  set ageRange(String value) {
    if (_ageRange != value) {
      _ageRange = value;
      notifyListeners();
    }
  }

  String get profession => _profession;
  set profession(String value) {
    if (_profession != value) {
      _profession = value;
      notifyListeners();
    }
  }

  String get livesAlone => _livesAlone;
  set livesAlone(String value) {
    if (_livesAlone != value) {
      _livesAlone = value;
      notifyListeners();
    }
  }

  String get gender => _gender;
  set gender(String value) {
    if (_gender != value) {
      _gender = value;
      notifyListeners();
    }
  }

  String get availableTime => _availableTime;
  set availableTime(String value) {
    if (_availableTime != value) {
      _availableTime = value;
      notifyListeners();
    }
  }

  String get hobbies => _hobbies;
  set hobbies(String value) {
    if (_hobbies != value) {
      _hobbies = value;
      notifyListeners();
    }
  }

  bool get receivesNotifications => _receivesNotifications;
  set receivesNotifications(bool value) {
    if (_receivesNotifications != value) {
      _receivesNotifications = value;
      notifyListeners();
    }
  }

  int get dailyStreak => _dailyStreak;
  set dailyStreak(int value) {
    if (_dailyStreak != value) {
      _dailyStreak = value;
      notifyListeners();
    }
  }

  bool get isAnonymous => _isAnonymous;
  set isAnonymous(bool value) {
    if (_isAnonymous != value) {
      _isAnonymous = value;
      notifyListeners();
    }
  }

  String get uid => _uid;
  set uid(String value) {
    if (_uid != value) {
      _uid = value;
      notifyListeners();
    }
  }

  // Helper method to create an anonymous user
  void setAsAnonymous(String userType, {String? profession, String? ageRange}) {
    _isAnonymous = true;
    _userType = userType;
    if (profession != null) _profession = profession;
    if (ageRange != null) _ageRange = ageRange;
    notifyListeners();
  }

  // Convert model to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': _email,
      'userType': _userType,
      'name': _name,
      'ageRange': _ageRange,
      'profession': _profession,
      'livesAlone': _livesAlone,
      'gender': _gender,
      'availableTime': _availableTime,
      'hobbies': _hobbies,
      'receivesNotifications': _receivesNotifications,
      'dailyStreak': _dailyStreak,
      'isAnonymous': _isAnonymous,
    };
  }

  // Create model from a Firestore document
  static RegistrationData fromMap(Map<String, dynamic> map, String uid) {
    final data = RegistrationData()
      ..email = map['email'] ?? ''
      ..userType = map['userType'] ?? 'Estudante'
      ..name = map['name'] ?? ''
      ..ageRange = map['ageRange'] ?? ''
      ..profession = map['profession'] ?? ''
      ..livesAlone = map['livesAlone'] ?? 'nao'
      ..gender = map['gender'] ?? 'masc'
      ..availableTime = map['availableTime'] ?? ''
      ..hobbies = map['hobbies'] ?? ''
      ..receivesNotifications = map['receivesNotifications'] ?? true
      ..dailyStreak = map['dailyStreak'] ?? 0
      ..isAnonymous = map['isAnonymous'] ?? false
      ..uid = uid;
    return data;
  }
}
