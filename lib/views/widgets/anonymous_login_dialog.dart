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
  String _selectedUserType = '';
  String? _profession;
  String? _ageRange;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acesso Anônimo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text('Selecione o tipo de usuário:'),
            const SizedBox(height: 10),
            _buildUserTypeSelector(),
            const SizedBox(height: 20),
            const Text('Opcionalmente, informe:'),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Profissão',
                hintText: 'Ex: Estudante, Professor, etc.',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _profession = value,
            ),
            const SizedBox(height: 10),
            _buildAgeRangeDropdown(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 10),
                Consumer<UserController>(
                  builder: (context, userController, child) {
                    return ElevatedButton(
                      onPressed: _selectedUserType.isEmpty || userController.isLoading
                          ? null
                          : () async {
                              final success = await userController.signInAnonymously(
                                _selectedUserType,
                                profession: _profession,
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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

  Widget _buildUserTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SelectableButton(
          text: "Estudante",
          isSelected: _selectedUserType == 'Estudante',
          onPressed: () {
            setState(() {
              _selectedUserType = 'Estudante';
            });
          },
        ),
        const SizedBox(width: 10),
        SelectableButton(
          text: "Colaborador",
          isSelected: _selectedUserType == 'Colaborador',
          onPressed: () {
            setState(() {
              _selectedUserType = 'Colaborador';
            });
          },
        ),
      ],
    );
  }

  Widget _buildAgeRangeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Faixa Etária',
        border: OutlineInputBorder(),
      ),
      value: _ageRange,
      hint: const Text('Selecione'),
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