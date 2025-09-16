// lib/screens/widgets_test_page.dart

import 'package:flutter/material.dart';
import '../widgets/buttons/primaryButton.dart';

class WidgetsTestPage extends StatefulWidget {
  const WidgetsTestPage({Key? key}) : super(key: key);

  @override
  State<WidgetsTestPage> createState() => _WidgetsTestPageState();
}

class _WidgetsTestPageState extends State<WidgetsTestPage> {
  // Estados para botões toggle
  bool isStudentSelected = false;
  bool isCollaboratorSelected = false;
  bool isOption1Selected = false;
  bool isOption2Selected = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Widgets'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da página
            const Text(
              'Teste de Botões Reutilizáveis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            
            // Seção 1: Botões Primários
            _buildSectionTitle('Botões Primários'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão primário padrão
                 PrimaryButton.primary(
                  text: 'Botão Padrão',
                  width: 150,
                ),
                
                // Botão primário com cor personalizada
                PrimaryButton.primary(
                  text: 'Verde',
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  width: 150,
                ),
                
                // Botão primário com texto personalizado
                PrimaryButton.primary(
                  text: 'Texto Vermelho',
                  onPressed: () {},
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.red,
                  width: 150,
                ),
                
                // Botão primário grande
                PrimaryButton.primary(
                  text: 'Botão Grande',
                  onPressed: () {},
                  width: 200,
                  height: 60,
                ),
                
                // Botão primário pequeno
                PrimaryButton.primary(
                  text: 'Pequeno',
                  onPressed: () {},
                  width: 100,
                  height: 40,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 2: Botões Toggle
            _buildSectionTitle('Botões Toggle'),
            Column(
              children: [
                // Exemplo de toggle único
                PrimaryButton.toggle(
                  text: 'Opção Toggle',
                  isSelected: isOption1Selected,
                  onPressed: () {
                    setState(() {
                      isOption1Selected = !isOption1Selected;
                    });
                  },
                  width: 200,
                ),
                
                const SizedBox(height: 16),
                
                // Exemplo de toggle em grupo (exclusivo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton.toggle(
                      text: 'Estudante',
                      isSelected: isStudentSelected,
                      onPressed: () {
                        setState(() {
                          isStudentSelected = !isStudentSelected;
                          if (isStudentSelected) isCollaboratorSelected = false;
                        });
                      },
                      width: 120,
                    ),
                    const SizedBox(width: 16),
                    PrimaryButton.toggle(
                      text: 'Colaborador',
                      isSelected: isCollaboratorSelected,
                      onPressed: () {
                        setState(() {
                          isCollaboratorSelected = !isCollaboratorSelected;
                          if (isCollaboratorSelected) isStudentSelected = false;
                        });
                      },
                      width: 120,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Exemplo de toggle múltiplo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton.toggle(
                      text: 'Opção 1',
                      isSelected: isOption1Selected,
                      onPressed: () {
                        setState(() {
                          isOption1Selected = !isOption1Selected;
                        });
                      },
                      width: 100,
                    ),
                    const SizedBox(width: 16),
                    PrimaryButton.toggle(
                      text: 'Opção 2',
                      isSelected: isOption2Selected,
                      onPressed: () {
                        setState(() {
                          isOption2Selected = !isOption2Selected;
                        });
                      },
                      width: 100,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 3: Botões com Gradiente
            _buildSectionTitle('Botões com Gradiente'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Gradiente azul para verde
                PrimaryButton(
                  text: 'Azul-Verde',
                  onPressed: () {},
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  width: 150,
                ),
                
                // Gradiente vermelho para amarelo
                PrimaryButton(
                  text: 'Vermelho-Amarelo',
                  onPressed: () {},
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.yellow],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  width: 150,
                ),
                
                // Gradiente roxo para rosa
                PrimaryButton(
                  text: 'Roxo-Rosa',
                  onPressed: () {},
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 150,
                ),
                
                // Gradiente com ícone
                PrimaryButton(
                  text: 'Com Ícone',
                  icon: Icons.star,
                  onPressed: () {},
                  gradient: const LinearGradient(
                    colors: [Colors.teal, Colors.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  width: 150,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 4: Botões apenas com Ícone
            _buildSectionTitle('Botões apenas com Ícone'),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Ícone padrão
                PrimaryButton.iconOnly(
                  icon: Icons.add,
                ),
                
                // Ícone com cor personalizada
                PrimaryButton.iconOnly(
                  icon: Icons.favorite,
                  backgroundColor: Colors.red,
                  iconColor: Colors.white,
                  onPressed: () {},
                ),
                
                // Ícone grande
                PrimaryButton.iconOnly(
                  icon: Icons.home,
                  backgroundColor: Colors.green,
                  size: 60,
                  iconSize: 32,
                  onPressed: () {},
                ),
                
                // Ícone pequeno
                PrimaryButton.iconOnly(
                  icon: Icons.search,
                  backgroundColor: Colors.amber,
                  size: 36,
                  iconSize: 18,
                  onPressed: () {},
                ),
                
                // Ícone redondo
                PrimaryButton.iconOnly(
                  icon: Icons.settings,
                  backgroundColor: Colors.purple,
                  size: 50,
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 5: Botões apenas com Texto
            _buildSectionTitle('Botões apenas com Texto'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texto padrão
                PrimaryButton.textOnly(
                  text: 'Botão de Texto Padrão',
                ),
                
                const SizedBox(height: 12),
                
                // Texto com cor personalizada
                PrimaryButton.textOnly(
                  text: 'Texto Vermelho',
                  textColor: Colors.red,
                  onPressed: () {},
                ),
                
                const SizedBox(height: 12),
                
                // Texto grande
                PrimaryButton.textOnly(
                  text: 'Texto Grande',
                  textColor: Colors.blue,
                  textSize: 20,
                  onPressed: () {},
                ),
                
                const SizedBox(height: 12),
                
                // Texto pequeno
                PrimaryButton.textOnly(
                  text: 'Texto Pequeno',
                  textColor: Colors.green,
                  textSize: 12,
                  onPressed: () {},
                ),
                
                const SizedBox(height: 12),
                
                // Texto com negrito
                PrimaryButton.textOnly(
                  text: 'Texto em Negrito',
                  textColor: Colors.purple,
                  textSize: 16,
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 6: Botões com Ícone e Texto
            _buildSectionTitle('Botões com Ícone e Texto'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Padrão
                 PrimaryButton.iconText(
                  text: 'Perfil',
                  icon: Icons.person,
                  width: 150,
                ),
                
                // Com cor personalizada
                PrimaryButton.iconText(
                  text: 'Configurações',
                  icon: Icons.settings,
                  onPressed: () {},
                  backgroundColor: Colors.orange,
                  width: 150,
                ),
                
                // Ícone e texto com cores diferentes
                PrimaryButton.iconText(
                  text: 'Notificações',
                  icon: Icons.notifications,
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  textColor: Colors.yellow,
                  iconColor: Colors.white,
                  width: 150,
                ),
                
                // Botão grande
                PrimaryButton.iconText(
                  text: 'Download',
                  icon: Icons.download,
                  onPressed: () {},
                  backgroundColor: Colors.teal,
                  width: 180,
                  height: 60,
                ),
                
                // Botão pequeno
                PrimaryButton.iconText(
                  text: 'Compartilhar',
                  icon: Icons.share,
                  onPressed: () {},
                  backgroundColor: Colors.indigo,
                  width: 120,
                  height: 40,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 7: Botões Desabilitados
            _buildSectionTitle('Botões Desabilitados'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão primário desabilitado
                 PrimaryButton.primary(
                  text: 'Desabilitado',
                  onPressed: null,
                  width: 150,
                ),
                
                // Botão toggle desabilitado
                 PrimaryButton.toggle(
                  text: 'Desabilitado',
                  isSelected: false,
                  onPressed: null,
                  width: 150,
                ),
                
                // Botão de ícone desabilitado
                 PrimaryButton.iconOnly(
                  icon: Icons.block,
                  onPressed: null,
                ),
                
                // Botão de texto desabilitado
                 PrimaryButton.textOnly(
                  text: 'Desabilitado',
                  onPressed: null,
                ),
                
                // Botão com ícone e texto desabilitado
                 PrimaryButton.iconText(
                  text: 'Desabilitado',
                  icon: Icons.not_interested,
                  onPressed: null,
                  width: 150,
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Widget auxiliar para criar títulos de seção
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}