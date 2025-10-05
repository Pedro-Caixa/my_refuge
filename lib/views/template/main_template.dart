import 'package:flutter/material.dart';

class MainTemplate extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int)? onItemTapped; // Tornou opcional com "?"
  final String? title;
  final Color? backgroundColor;
  final bool transparentAppBar;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? customBottomNavigationBar;

  const MainTemplate({
    Key? key,
    required this.body,
    required this.currentIndex,
    this.onItemTapped, // Não é mais obrigatório
    this.title,
    this.backgroundColor,
    this.transparentAppBar = false,
    this.actions,
    this.leading,
    this.customBottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: transparentAppBar ? Colors.transparent : null,
              elevation: transparentAppBar ? 0 : null,
              leading: leading,
              actions: actions,
            )
          : null,
      body: body,
      bottomNavigationBar: customBottomNavigationBar,
    );
  }
}
