import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cosecha_app/l10n/app_localizations.dart';

import '../services/image_storage_service.dart';

class ImagePickerField extends StatefulWidget {
  const ImagePickerField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  bool _loading = false;

  Future<void> _pick(ImageSource source) async {
    if (_loading || !widget.enabled) return;
    setState(() => _loading = true);
    final path = await ImageStorageService.pickAndSaveImage(source: source);
    if (mounted) {
      setState(() => _loading = false);
      if (path != null) {
        widget.onChanged(path);
      }
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.imagePickerCamera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.imagePickerGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(ImageSource.gallery);
                },
              ),
              if (widget.value != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(l10n.imagePickerRemove),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onChanged(null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.4);
    final imagePath = widget.value?.trim() ?? '';
    final hasValidImage = imagePath.isNotEmpty && File(imagePath).existsSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: widget.enabled ? _showPickerSheet : null,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : !hasValidImage
                ? const Center(
                    child: Icon(Icons.add_a_photo_outlined, size: 32),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(imagePath), fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }
}
