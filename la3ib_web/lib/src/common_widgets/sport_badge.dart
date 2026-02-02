import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_typography.dart';

class SportBadge extends StatelessWidget {
  const SportBadge({
    super.key,
    required this.sport,
    this.size = SportBadgeSize.medium,
  });

  final String sport;
  final SportBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final color = BrandColors.getSportColor(sport);
    final iconSize = size == SportBadgeSize.small ? 16.0 : 24.0;
    final fontSize = size == SportBadgeSize.small ? 10.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == SportBadgeSize.small ? 8 : 12,
        vertical: size == SportBadgeSize.small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getSportIcon(sport), size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            sport,
            style: BrandTypography.labelSmall(color: color).copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'padel':
      case 'tennis':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }
}

enum SportBadgeSize { small, medium }