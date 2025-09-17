import 'package:flutter/material.dart';
import '../widgets/buttons/custom_button.dart';

/// Test page to demonstrate the CustomButton widget capabilities.
class CustomButtonTestPage extends StatefulWidget {
  const CustomButtonTestPage({Key? key}) : super(key: key);

  @override
  State<CustomButtonTestPage> createState() => _CustomButtonTestPageState();
}

class _CustomButtonTestPageState extends State<CustomButtonTestPage> {
  bool _isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Operação concluída!');
      }
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomButton Widget Test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            const Text(
              'CustomButton Widget Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demonstrating all CustomButton features and layout variations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Navigation to example usage
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exemplo Prático',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Veja como usar o CustomButton em uma tela de login real',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Ver Exemplo de Login',
                    icon: Icons.launch,
                    backgroundColor: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/custom-button-example'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 1: Basic Layout Types
            _buildSectionTitle('1. Basic Layout Types'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Text only
                CustomButton(
                  text: 'Text Only',
                  onPressed: () => _showSnackBar('Text only button pressed!'),
                ),
                
                // Icon only
                CustomButton(
                  icon: Icons.favorite,
                  onPressed: () => _showSnackBar('Icon only button pressed!'),
                  semanticLabel: 'Favorite button',
                ),
                
                // Icon + Text
                CustomButton(
                  text: 'Icon + Text',
                  icon: Icons.login,
                  onPressed: () => _showSnackBar('Icon + Text button pressed!'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 2: Different Colors
            _buildSectionTitle('2. Color Variations'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Default (Primary theme color)
                CustomButton(
                  text: 'Default',
                  onPressed: () => _showSnackBar('Default color pressed!'),
                ),
                
                // Custom background colors
                CustomButton(
                  text: 'Green',
                  icon: Icons.check,
                  backgroundColor: Colors.green,
                  onPressed: () => _showSnackBar('Green button pressed!'),
                ),
                
                CustomButton(
                  text: 'Orange',
                  icon: Icons.warning,
                  backgroundColor: Colors.orange,
                  onPressed: () => _showSnackBar('Orange button pressed!'),
                ),
                
                CustomButton(
                  text: 'Red',
                  icon: Icons.error,
                  backgroundColor: Colors.red,
                  onPressed: () => _showSnackBar('Red button pressed!'),
                ),
                
                // Custom text/icon colors
                CustomButton(
                  text: 'Custom Colors',
                  icon: Icons.palette,
                  backgroundColor: Colors.black,
                  textColor: Colors.yellow,
                  iconColor: Colors.cyan,
                  onPressed: () => _showSnackBar('Custom colors pressed!'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 3: Icon Only Variations
            _buildSectionTitle('3. Icon Only Buttons'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CustomButton(
                  icon: Icons.add,
                  backgroundColor: Colors.blue,
                  onPressed: () => _showSnackBar('Add button pressed!'),
                  semanticLabel: 'Add item',
                ),
                
                CustomButton(
                  icon: Icons.edit,
                  backgroundColor: Colors.amber,
                  onPressed: () => _showSnackBar('Edit button pressed!'),
                  semanticLabel: 'Edit item',
                ),
                
                CustomButton(
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                  onPressed: () => _showSnackBar('Delete button pressed!'),
                  semanticLabel: 'Delete item',
                ),
                
                CustomButton(
                  icon: Icons.share,
                  backgroundColor: Colors.purple,
                  onPressed: () => _showSnackBar('Share button pressed!'),
                  semanticLabel: 'Share item',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 4: Different Sizes and Styling
            _buildSectionTitle('4. Size and Style Variations'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Small button
                CustomButton(
                  text: 'Small',
                  fontSize: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onPressed: () => _showSnackBar('Small button pressed!'),
                ),
                
                // Large button
                CustomButton(
                  text: 'Large Button',
                  icon: Icons.launch,
                  fontSize: 20,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  onPressed: () => _showSnackBar('Large button pressed!'),
                ),
                
                // Wide button
                CustomButton(
                  text: 'Wide Button',
                  icon: Icons.expand,
                  width: 200,
                  onPressed: () => _showSnackBar('Wide button pressed!'),
                ),
                
                // Different border radius
                CustomButton(
                  text: 'Rounded',
                  icon: Icons.circle,
                  borderRadius: 25,
                  backgroundColor: Colors.teal,
                  onPressed: () => _showSnackBar('Rounded button pressed!'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 5: Loading States
            _buildSectionTitle('5. Loading States'),
            Column(
              children: [
                CustomButton(
                  text: _isLoading ? 'Loading...' : 'Simulate Loading',
                  icon: _isLoading ? null : Icons.play_arrow,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _simulateLoading,
                  backgroundColor: Colors.indigo,
                ),
                
                const SizedBox(height: 16),
                
                // Icon only loading
                CustomButton(
                  icon: Icons.refresh,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _simulateLoading,
                  backgroundColor: Colors.green,
                  semanticLabel: 'Refresh data',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 6: Disabled States
            _buildSectionTitle('6. Disabled States'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                const CustomButton(
                  text: 'Disabled Text',
                  onPressed: null,
                ),
                
                const CustomButton(
                  icon: Icons.block,
                  onPressed: null,
                  semanticLabel: 'Disabled icon button',
                ),
                
                const CustomButton(
                  text: 'Disabled Both',
                  icon: Icons.not_interested,
                  onPressed: null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 7: Accessibility Demo
            _buildSectionTitle('7. Accessibility Features'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The CustomButton includes proper accessibility support:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Semantic labels for screen readers'),
                  const Text('• Proper button semantics'),
                  const Text('• Enabled/disabled state announcements'),
                  const SizedBox(height: 16),
                  CustomButton(
                    icon: Icons.accessibility,
                    text: 'Accessible Button',
                    backgroundColor: Colors.green,
                    semanticLabel: 'This is an accessible button with custom semantic label',
                    onPressed: () => _showSnackBar('Accessible button pressed!'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 8: Usage Examples
            _buildSectionTitle('8. Common Usage Examples'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Login button
                CustomButton(
                  text: 'Entrar',
                  icon: Icons.login,
                  backgroundColor: Colors.blue,
                  onPressed: () => _showSnackBar('Login button pressed!'),
                ),
                
                const SizedBox(height: 12),
                
                // Sign up button
                CustomButton(
                  text: 'Criar Conta',
                  icon: Icons.person_add,
                  backgroundColor: Colors.green,
                  onPressed: () => _showSnackBar('Sign up button pressed!'),
                ),
                
                const SizedBox(height: 12),
                
                // Cancel button
                CustomButton(
                  text: 'Cancelar',
                  backgroundColor: Colors.grey,
                  onPressed: () => _showSnackBar('Cancel button pressed!'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}