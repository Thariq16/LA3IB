import 'package:flutter/material.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../theme/brand_colors.dart';

/// Widget that displays user statistics (games organized, joined, member since)
class UserStatsWidget extends StatelessWidget {
  const UserStatsWidget({
    super.key,
    required this.gamesOrganized,
    required this.gamesJoined,
    required this.memberSince,
  });

  final int gamesOrganized;
  final int gamesJoined;
  final DateTime? memberSince;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: 'Organized',
            value: gamesOrganized.toString(),
            icon: Icons.sports_soccer,
          ),
          _VerticalDivider(),
          _StatItem(
            label: 'Joined',
            value: gamesJoined.toString(),
            icon: Icons.group,
          ),
          _VerticalDivider(),
          _StatItem(
            label: 'Member Since',
            value: _formatDate(memberSince),
            icon: Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: BrandColors.primaryGreen,
          size: 24,
        ),
        gapH8,
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        gapH4,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
    );
  }
}
