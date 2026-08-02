import 'package:flutter/material.dart';

class AcademicLocationBar extends StatelessWidget {
  const AcademicLocationBar({
    super.key,
    required this.items,
    required this.semanticLabel,
  });

  final List<AcademicLocationItem> items;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: '$semanticLabel: ${items.map((item) => item.label).join(', ')}',
      container: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.secondaryContainer.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var index = 0; index < items.length; index++) ...[
              if (index > 0)
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: colors.onSecondaryContainer.withValues(alpha: .6),
                ),
              Icon(
                items[index].icon,
                size: 17,
                color: colors.onSecondaryContainer,
              ),
              Text(
                items[index].label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.onSecondaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AcademicLocationItem {
  const AcademicLocationItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
