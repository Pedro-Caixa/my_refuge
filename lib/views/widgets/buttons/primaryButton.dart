// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  toggle,
  iconOnly,
  textOnly,
  iconText,
}

class PrimaryButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType buttonType;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? selectedColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double textSize;
  final FontWeight fontWeight;
  final Gradient? gradient;
  final bool isEnabled;

  const PrimaryButton({
    Key? key,
    this.text,
    this.icon,
    this.onPressed,
    this.buttonType = ButtonType.primary,
    this.isSelected = false,
    this.backgroundColor,
    this.textColor,
    this.selectedColor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.iconSize = 24.0,
    this.textSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.gradient,
    this.isEnabled = true,
  }) : super(key: key);

  // Construtores nomeados para facilitar o uso
  PrimaryButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    double? height,
    Gradient? gradient,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          buttonType: ButtonType.primary,
          backgroundColor: backgroundColor ?? Colors.blue,
          textColor: textColor ?? Colors.white,
          width: width,
          height: height,
          gradient: gradient,
        );

  PrimaryButton.toggle({
    Key? key,
    required String text,
    required bool isSelected,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? selectedColor,
    Color? textColor,
    double? width,
    double? height,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          buttonType: ButtonType.toggle,
          isSelected: isSelected,
          backgroundColor: backgroundColor ?? Colors.transparent,
          selectedColor: selectedColor ?? Colors.blue.shade100,
          textColor: textColor ?? Colors.blue,
          width: width,
          height: height,
        );

  PrimaryButton.iconOnly({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    double? size,
    double? iconSize,
  }) : this(
          key: key,
          icon: icon,
          onPressed: onPressed,
          buttonType: ButtonType.iconOnly,
          backgroundColor: backgroundColor ?? Colors.blue,
          textColor: iconColor ?? Colors.white,
          width: size ?? 48,
          height: size ?? 48,
          iconSize: iconSize ?? 24,
        );

  PrimaryButton.textOnly({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    double? textSize,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          buttonType: ButtonType.textOnly,
          backgroundColor: Colors.transparent,
          textColor: textColor ?? Colors.blue,
          textSize: textSize ?? 16,
        );

  PrimaryButton.iconText({
    Key? key,
    required String text,
    required IconData icon,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    double? width,
    double? height,
  }) : this(
          key: key,
          text: text,
          icon: icon,
          onPressed: onPressed,
          buttonType: ButtonType.iconText,
          backgroundColor: backgroundColor ?? Colors.blue,
          textColor: textColor ?? Colors.white,
          width: width,
          height: height,
        );

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    final Color effectiveBackgroundColor = _getBackgroundColor();
    final Color effectiveTextColor = _getTextColor();
    final Gradient? effectiveGradient = gradient;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              color: effectiveGradient == null ? effectiveBackgroundColor : null,
              gradient: effectiveGradient,
              borderRadius: BorderRadius.circular(borderRadius),
              border: buttonType == ButtonType.toggle
                  ? Border.all(
                      color: isSelected
                          ? (selectedColor ?? Colors.blue)
                          : (borderColor ?? Colors.grey.shade300),
                      width: 1.5,
                    )
                  : null,
            ),
            padding: padding,
            child: Center(
              child: _buildContent(effectiveTextColor),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isEnabled) return Colors.grey.shade300;
    
    if (buttonType == ButtonType.toggle) {
      return isSelected ? (selectedColor ?? Colors.blue.shade100) : (backgroundColor ?? Colors.transparent);
    }
    
    return backgroundColor ?? Colors.blue;
  }

  Color _getTextColor() {
    if (!isEnabled) return Colors.grey.shade600;
    
    if (buttonType == ButtonType.toggle) {
      return isSelected ? (selectedColor ?? Colors.blue) : (textColor ?? Colors.blue);
    }
    
    return textColor ?? Colors.white;
  }

  Widget _buildContent(Color textColor) {
    switch (buttonType) {
      case ButtonType.iconOnly:
        return Icon(
          icon,
          color: textColor,
          size: iconSize,
        );
        
      case ButtonType.textOnly:
        return Text(
          text ?? '',
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: fontWeight,
          ),
        );
        
      case ButtonType.iconText:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: iconSize,
            ),
            const SizedBox(width: 8),
            Text(
              text ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        );
        
      default: // primary e toggle
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor,
                size: iconSize,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        );
    }
  }
}