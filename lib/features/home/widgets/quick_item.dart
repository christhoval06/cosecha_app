import 'dart:io';

import 'package:flutter/material.dart';

class QuickItem extends StatelessWidget {
  final String label;
  final String? imagePath;
  final VoidCallback? onTap;

  const QuickItem({super.key, required this.label, this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final safeImagePath = imagePath?.trim() ?? '';
    final hasValidImage =
        safeImagePath.isNotEmpty && File(safeImagePath).existsSync();
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
              image: hasValidImage
                  ? DecorationImage(
                      image: FileImage(File(safeImagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasValidImage
                ? const Icon(Icons.inventory_2_outlined)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
