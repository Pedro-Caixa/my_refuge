import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;
  final List<Color> gradientColors;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final bool isLoading;

  const MainButton({
    Key? key,
    this.onPressed,
    this.text,
    this.icon,
    this.gradientColors = const [Color(0xFF4AA9FF), Color(0xFF55E1D2)],
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.child,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onPressed,
            child: Padding(
              padding: padding,
              child: Center(
                child: _buildContent(Theme.of(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    if (icon != null && text != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor ?? Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            text!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (icon != null) {
      return Icon(
        icon,
        color: textColor ?? Colors.white,
        size: 24,
      );
    } else if (text != null) {
      return Text(
        text!,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
