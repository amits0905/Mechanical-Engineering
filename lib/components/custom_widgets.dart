import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced reusable custom TextField widget with full customization
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters; // ✅ Added

  // Enhanced properties
  final TextStyle? style;
  final InputDecoration? decoration;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? errorText;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.readOnly = false,
    this.textAlign = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.inputFormatters, // ✅ Added
    // Enhanced properties
    this.style,
    this.decoration,
    this.fillColor,
    this.borderRadius = 12.0,
    this.contentPadding,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    final effectiveStyle = style ?? defaultStyle;

    final defaultDecoration = InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: fillColor ?? Colors.grey.shade100,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        borderSide: const BorderSide(color: Color(0xFF2E6AFE), width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
    );

    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: effectiveStyle,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: enabled,
      inputFormatters: inputFormatters, // ✅ Added
      decoration: decoration ?? defaultDecoration,
    );
  }
}

/// Specialized TextField for conversion applications
class ConversionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color primaryColor;
  final Color backgroundColor;
  final double fontSize;
  final List<TextInputFormatter>? inputFormatters; // ✅ Added

  const ConversionTextField({
    super.key,
    required this.controller,
    this.hintText = '0.0',
    this.primaryColor = const Color(0xFF2E5BFF),
    this.backgroundColor = const Color(0xFFF0F4F8),
    this.fontSize = 28.0,
    this.inputFormatters, // ✅ Added
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveFillColor = backgroundColor.withAlpha(
      (0.5 * 255).round(),
    );

    return CustomTextField(
      controller: controller,
      hintText: hintText,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: inputFormatters, // ✅ Added
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      fillColor: effectiveFillColor,
      borderRadius: 15.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }
}

/// Common reusable custom Button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double fontSize;
  final bool uppercase;
  final Widget? child;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFF2E6AFE),
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.height = 48,
    this.fontSize = 16,
    this.uppercase = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 3,
          disabledBackgroundColor: backgroundColor.withAlpha(80),
        ),
        child:
            child ??
            Text(
              uppercase ? text.toUpperCase() : text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 1.1,
              ),
            ),
      ),
    );
  }
}

/// Common reusable custom Dropdown widget
class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double borderRadius;
  final Color backgroundColor;
  final double height;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFFF5F6FA),
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
