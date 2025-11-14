import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import './buttons/selectable_button.dart';

class AnonymousLoginDialog extends StatefulWidget {
  const AnonymousLoginDialog({Key? key}) : super(key: key);

  @override
  _AnonymousLoginDialogState createState() => _AnonymousLoginDialogState();
}

class _AnonymousLoginDialogState extends State<AnonymousLoginDialog> {
  String? _selectedUserType;
  DateTime? _birthDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1924),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4DD0E1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4DD0E1),
              Color(0xFF4DD0E1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acesso Anônimo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Informe:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tipo de Usuário',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color(0xFF4DD0E1),
              value: _selectedUserType,
              hint: const Text(
                'Selecione',
                style: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
              items: const [
                DropdownMenuItem(value: 'Estudante', child: Text('Estudante')),
                DropdownMenuItem(
                    value: 'Colaborador', child: Text('Colaborador')),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
                labelStyle: const TextStyle(color: Colors.white),
                hintText: 'DD/MM/AAAA',
                hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Consumer<UserController>(
                  builder: (context, userController, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _selectedUserType == null ||
                              _birthDate == null ||
                              userController.isLoading
                          ? null
                          : () async {
                              // Formata a data de nascimento (ISO 8601)
                              final birthDateString =
                                  _birthDate!.toIso8601String();

                              final success =
                                  await userController.signInAnonymously(
                                _selectedUserType!,
                                ageRange: birthDateString,
                              );

                              if (success && mounted) {
                                Navigator.pop(context, true);
                              }
                            },
                      child: userController.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continuar'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
