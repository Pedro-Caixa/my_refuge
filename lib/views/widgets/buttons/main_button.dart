import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double textSize;
  final FontWeight fontWeight;
  final IconData? icon;
  final bool isLoading;
  final double elevation;
  final double disabledElevation;

  const MainButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.textSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.icon,
    this.isLoading = false,
    this.elevation = 4.0,
    this.disabledElevation = 0.0,
  }) : super(key: key);

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    final Color effectiveTextColor = widget.textColor ?? 
        (widget.backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: isEnabled ? widget.backgroundColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: _isPressed ? 2 : widget.elevation,
            offset: _isPressed ? const Offset(0, 1) : const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? widget.onPressed : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Padding(
            padding: widget.padding,
            child: Center(
              child: _buildContent(effectiveTextColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (widget.isLoading) {
      return SizedBox(
        height: widget.textSize + 8,
        width: widget.textSize + 8,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: textColor,
            size: widget.textSize + 4,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: TextStyle(
            color: textColor,
            fontSize: widget.textSize,
            fontWeight: widget.fontWeight,
          ),
        ),
      ],
    );
  }
}