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
  String? _ageRange;

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
            _buildAgeRangeDropdown(),
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
                              _ageRange == null ||
                              userController.isLoading
                          ? null
                          : () async {
                              final success =
                                  await userController.signInAnonymously(
                                _selectedUserType!,
                                ageRange: _ageRange,
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

  Widget _buildAgeRangeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Faixa Etária',
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      dropdownColor: const Color(0xFF4DD0E1),
      value: _ageRange,
      hint: const Text(
        'Selecione',
        style: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _ageRange = value;
        });
      },
      items: const [
        DropdownMenuItem(value: '18-25', child: Text('18-25 anos')),
        DropdownMenuItem(value: '26-35', child: Text('26-35 anos')),
        DropdownMenuItem(value: '36-45', child: Text('36-45 anos')),
        DropdownMenuItem(value: '46-60', child: Text('46-60 anos')),
        DropdownMenuItem(value: '61+', child: Text('61+ anos')),
      ],
    );
  }
}
