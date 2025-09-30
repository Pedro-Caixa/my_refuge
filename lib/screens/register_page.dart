import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// DATA_MODEL
class RegistrationData extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _userType = 'paciente';
  String _name = '';
  String _ageRange = '';
  String _profession = '';
  String _livesAlone = 'nao';
  String _gender = 'masc';
  String _availableTime = '';
  String _hobbies = '';
  bool _receivesNotifications = true;

  RegistrationData();

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
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    final registrationData = Provider.of<RegistrationData>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4DD0E1), Color(0xFF80DEEA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      "Voltar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.home, size: 60, color: Colors.teal),
                ),
                const Text(
                  "Bem-vindo ao My Refuge",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Seu refúgio para o bem-estar emocional",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => registrationData.email = value,
                        decoration: InputDecoration(
                          labelText: "Email *",
                          hintText: "seu@email.com",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        obscureText: true,
                        onChanged: (value) => registrationData.password = value,
                        decoration: InputDecoration(
                          labelText: "Senha *",
                          hintText: "Sua senha",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          suffixIcon: const Icon(Icons.visibility),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        obscureText: true,
                        onChanged: (value) =>
                            registrationData.confirmPassword = value,
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha *",
                          hintText: "Confirme sua senha",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          suffixIcon: const Icon(Icons.visibility),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<RegistrationData>(
                        builder: (context, model, child) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Tipo de Usuário *",
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                            value: model.userType,
                            items: const [
                              DropdownMenuItem<String>(
                                value: "paciente",
                                child: Text("Paciente"),
                              ),
                              DropdownMenuItem<String>(
                                value: "profissional",
                                child: Text("Profissional"),
                              ),
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                model.userType = value;
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Informações Opcionais",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (value) => registrationData.name = value,
                        decoration: InputDecoration(
                          labelText: "Nome",
                          hintText: "Seu nome",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) => registrationData.ageRange = value,
                        decoration: InputDecoration(
                          labelText: "Faixa Etária",
                          hintText: "Idade",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (value) =>
                            registrationData.profession = value,
                        decoration: InputDecoration(
                          labelText: "Profissão",
                          hintText: "Sua profissão",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<RegistrationData>(
                        builder: (context, model, child) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Mora Sozinho",
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                            value: model.livesAlone,
                            items: const [
                              DropdownMenuItem<String>(
                                value: "sim",
                                child: Text("Sim"),
                              ),
                              DropdownMenuItem<String>(
                                value: "nao",
                                child: Text("Não"),
                              ),
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                model.livesAlone = value;
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Consumer<RegistrationData>(
                        builder: (context, model, child) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Sexo",
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                            value: model.gender,
                            items: const [
                              DropdownMenuItem<String>(
                                value: "masc",
                                child: Text("Masculino"),
                              ),
                              DropdownMenuItem<String>(
                                value: "fem",
                                child: Text("Feminino"),
                              ),
                              DropdownMenuItem<String>(
                                value: "outro",
                                child: Text("Outro"),
                              ),
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                model.gender = value;
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) =>
                            registrationData.availableTime = value,
                        decoration: InputDecoration(
                          labelText: "Tempo Disponível",
                          hintText: "Ex: 2 horas por dia",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (value) => registrationData.hobbies = value,
                        decoration: InputDecoration(
                          labelText: "Hobbies",
                          hintText: "Seus hobbies e interesses",
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<RegistrationData>(
                        builder: (context, model, child) {
                          return Row(
                            children: [
                              Checkbox(
                                value: model.receivesNotifications,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    model.receivesNotifications = value;
                                  }
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "Receber notificações para lembrá-lo do bem-estar",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Criar Conta",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text("Prefere não criar uma conta?"),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.teal),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Usar Anonimamente",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
