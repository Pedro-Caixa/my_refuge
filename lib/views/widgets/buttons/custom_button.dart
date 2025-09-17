import 'package:flutter/material.dart';

/// A highly customizable button widget that supports various layouts and styling options.
/// 
/// The CustomButton supports:
/// - Icon-only, text-only, or icon+text layouts
/// - Material ink splash effect animations
/// - Flexible styling with default Material Design colors
/// - Proper accessibility support
/// - Custom padding and spacing for different variants
/// 
/// Example usage:
/// ```dart
/// // Text only button
/// CustomButton(
///   onPressed: () {},
///   text: "Entrar",
/// )
/// 
/// // Icon only button
/// CustomButton(
///   onPressed: () {},
///   icon: Icons.login,
/// )
/// 
/// // Icon with text button
/// CustomButton(
///   onPressed: () {},
///   text: "Entrar",
///   icon: Icons.login,
/// )
/// ```
class CustomButton extends StatefulWidget {
  /// The text to display on the button. Can be null for icon-only buttons.
  final String? text;
  
  /// The callback function called when the button is pressed.
  final VoidCallback? onPressed;
  
  /// The icon to display. Can be null for text-only buttons.
  final IconData? icon;
  
  /// The background color of the button. Defaults to Theme's primary color.
  final Color? backgroundColor;
  
  /// The text color. If null, automatically determined based on background luminance.
  final Color? textColor;
  
  /// The icon color. If null, uses the same color as text.
  final Color? iconColor;
  
  /// The width of the button. If null, wraps content.
  final double? width;
  
  /// The height of the button. If null, uses default height.
  final double? height;
  
  /// The border radius of the button corners.
  final double borderRadius;
  
  /// The padding inside the button.
  final EdgeInsetsGeometry? padding;
  
  /// The font size of the text.
  final double fontSize;
  
  /// The font weight of the text.
  final FontWeight fontWeight;
  
  /// The size of the icon.
  final double? iconSize;
  
  /// Whether the button is in loading state.
  final bool isLoading;
  
  /// The elevation of the button when enabled.
  final double elevation;
  
  /// The elevation of the button when disabled.
  final double disabledElevation;
  
  /// The spacing between icon and text when both are present.
  final double iconTextSpacing;
  
  /// The splash color for the ink effect.
  final Color? splashColor;
  
  /// The highlight color for the ink effect.
  final Color? highlightColor;
  
  /// Semantic label for accessibility.
  final String? semanticLabel;

  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.padding,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.iconSize,
    this.isLoading = false,
    this.elevation = 4.0,
    this.disabledElevation = 0.0,
    this.iconTextSpacing = 8.0,
    this.splashColor,
    this.highlightColor,
    this.semanticLabel,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided'),
       super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    
    // Determine effective colors
    final Color effectiveBackgroundColor = widget.backgroundColor ?? theme.primaryColor;
    final Color effectiveTextColor = widget.textColor ?? 
        _getContrastingColor(effectiveBackgroundColor);
    final Color effectiveIconColor = widget.iconColor ?? effectiveTextColor;
    final Color effectiveSplashColor = widget.splashColor ?? 
        Colors.white.withOpacity(0.3);
    final Color effectiveHighlightColor = widget.highlightColor ?? 
        Colors.white.withOpacity(0.1);
    
    // Determine layout type
    final bool hasText = widget.text != null && widget.text!.isNotEmpty;
    final bool hasIcon = widget.icon != null;
    final bool isIconOnly = hasIcon && !hasText;
    final bool isTextOnly = hasText && !hasIcon;
    
    // Calculate padding based on layout
    EdgeInsetsGeometry effectivePadding = widget.padding ?? _getDefaultPadding(isIconOnly, isTextOnly);
    
    // Calculate icon size
    final double effectiveIconSize = widget.iconSize ?? (widget.fontSize + 4);

    return Semantics(
      label: widget.semanticLabel ?? widget.text,
      button: true,
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: isEnabled ? effectiveBackgroundColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: _isPressed 
                  ? widget.disabledElevation + 1 
                  : (isEnabled ? widget.elevation : widget.disabledElevation),
              offset: _isPressed 
                  ? const Offset(0, 1) 
                  : const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: effectiveSplashColor,
            highlightColor: effectiveHighlightColor,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: effectivePadding,
              child: _buildContent(
                effectiveTextColor,
                effectiveIconColor,
                effectiveIconSize,
                hasText,
                hasIcon,
                isIconOnly,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the content of the button based on the layout type.
  Widget _buildContent(
    Color textColor,
    Color iconColor,
    double iconSize,
    bool hasText,
    bool hasIcon,
    bool isIconOnly,
  ) {
    if (widget.isLoading) {
      return _buildLoadingIndicator(textColor, iconSize, isIconOnly);
    }

    if (isIconOnly) {
      return _buildIconOnlyContent(iconColor, iconSize);
    }

    return _buildStandardContent(textColor, iconColor, iconSize, hasText, hasIcon);
  }

  /// Builds the loading indicator.
  Widget _buildLoadingIndicator(Color color, double iconSize, bool isIconOnly) {
    final double size = isIconOnly ? iconSize : (widget.fontSize + 8);
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  /// Builds icon-only button content.
  Widget _buildIconOnlyContent(Color iconColor, double iconSize) {
    return Icon(
      widget.icon,
      color: iconColor,
      size: iconSize,
    );
  }

  /// Builds standard button content (text, or icon+text).
  Widget _buildStandardContent(
    Color textColor,
    Color iconColor,
    double iconSize,
    bool hasText,
    bool hasIcon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasIcon) ...[
          Icon(
            widget.icon,
            color: iconColor,
            size: iconSize,
          ),
          if (hasText) SizedBox(width: widget.iconTextSpacing),
        ],
        if (hasText)
          Text(
            widget.text!,
            style: TextStyle(
              color: textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
      ],
    );
  }

  /// Returns a contrasting color based on the background luminance.
  Color _getContrastingColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  /// Returns default padding based on the button layout type.
  EdgeInsetsGeometry _getDefaultPadding(bool isIconOnly, bool isTextOnly) {
    if (isIconOnly) {
      return const EdgeInsets.all(12.0);
    } else if (isTextOnly) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
    } else {
      // Icon + text
      return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
    }
  }
}