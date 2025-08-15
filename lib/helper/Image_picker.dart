import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan_project/widget/bottom_sheet_container.dart';

class _ImagePickerContent extends StatelessWidget {
  const _ImagePickerContent();

  void _pickImage(ImageSource imageSource, BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? result = await picker.pickImage(source: imageSource);
    context.pop(result!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          child: const _ImagePickerType(
              icon: Icons.camera_alt_outlined, text: "Take Picture"),
          onTap: () {
            _pickImage(ImageSource.camera, context);
          },
        ),
        InkWell(
            child: const _ImagePickerType(
                icon: Icons.image_outlined, text: "Pick from Gallery"),
            onTap: () {
              _pickImage(ImageSource.gallery, context);
            })
      ],
    );
  }
}

class ImagePickerDialog {
  const ImagePickerDialog._();

  static Future<XFile?> pickImage(BuildContext context) async {
    final result = await BottomSheetContainer.showBottomSheet(
        context, const _ImagePickerContent());
    if (result is XFile?) return result;
    return null;
  }

  static Future<List<XFile>> pickImages(BuildContext context) async {
    final result = await BottomSheetContainer.showBottomSheet(
        context, const _ImageMultiplePickerContent());

    if (result is List<XFile>) return result;
    return [];
  }
}

class _ImageMultiplePickerContent extends StatelessWidget {
  const _ImageMultiplePickerContent();

  void _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.camera);
    if (result is XFile) {
      context.pop([result]);
      return;
    }
    context.pop([]);
  }

  void _pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> result = await picker.pickMultiImage();
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          child: const _ImagePickerType(
              icon: Icons.camera_alt_outlined, text: "Take Picture"),
          onTap: () {
            _pickImage(context);
          },
        ),
        InkWell(
            child: const _ImagePickerType(
                icon: Icons.image_outlined, text: "Pick from Gallery"),
            onTap: () {
              _pickImages(context);
            }),
      ],
    );
  }
}

class _ImagePickerType extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ImagePickerType({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(
          text,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
