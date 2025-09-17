import 'package:flutter/material.dart';

class SelectableButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isSelected;
  final double height;
  final double borderRadius;

  const SelectableButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.icon,
    required this.isSelected,
    this.height = 48.0,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : const Color(0xFF55E1D2),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF55E1D2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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