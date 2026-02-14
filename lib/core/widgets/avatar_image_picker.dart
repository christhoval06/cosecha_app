import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cosecha_app/l10n/app_localizations.dart';

class AvatarImagePicker extends StatefulWidget {
  const AvatarImagePicker({
    super.key,
    required this.onChanged,
    this.value,
    this.size = 120,
    this.enabled = true,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final double size;
  final bool enabled;

  @override
  State<AvatarImagePicker> createState() => _AvatarImagePickerState();
}

class _AvatarImagePickerState extends State<AvatarImagePicker> {
  bool _loading = false;

  Future<void> _pick(ImageSource source) async {
    if (_loading || !widget.enabled) return;
    setState(() => _loading = true);
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 60);
    final path = picked?.path;
    if (!mounted) return;
    setState(() => _loading = false);
    if (path != null) widget.onChanged(path);
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
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final avatarSize = widget.size;
    final badgeSize = avatarSize * 0.28;
    final imagePath = widget.value?.trim() ?? '';
    final hasValidImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    return SizedBox(
      width: avatarSize + badgeSize * 0.3,
      height: avatarSize + badgeSize * 0.3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            shape: const CircleBorder(),
            elevation: 8,
            shadowColor: shadowColor.withValues(alpha: 0.15),
            child: InkWell(
              onTap: widget.enabled ? _showPickerSheet : null,
              customBorder: const CircleBorder(),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.surface, width: 6),
                  image: hasValidImage
                      ? DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : !hasValidImage
                    ? Icon(
                        Icons.storefront,
                        size: avatarSize * 0.4,
                        color: colorScheme.primary,
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Material(
              shape: const CircleBorder(),
              color: colorScheme.primary,
              elevation: 6,
              child: InkWell(
                onTap: widget.enabled ? _showPickerSheet : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 4),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: badgeSize * 0.45,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
