import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CircularCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final double size;

  const CircularCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? AppTheme.primary : Colors.transparent,
          border: Border.all(
            color: isChecked ? AppTheme.primary : AppTheme.outlineVariant,
            width: 2.0,
          ),
          boxShadow: isChecked
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                size: size * 0.65,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

