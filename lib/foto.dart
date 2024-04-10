import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../banco.dart';

class Foto extends StatelessWidget {
  Foto({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    this.uUID,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final ImagePicker picker = ImagePicker();
  final String? uUID;
  final double size = 250;
  final double maxWidth = 500;
  final double maxHeight = 575;
  final int quality = 80; // inteiro de 0-100

  _recuperaFoto(XFile? image) async {
    final imageExtension = image?.path.split('.').last.toLowerCase();
    final imageBytes = await image?.readAsBytes();
    final userId = uUID;
    final imagePath = '/$userId/profile';
    await supabase.storage.from('bucket_fotos').uploadBinary(
          imagePath,
          imageBytes!,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$imageExtension',
          ),
        );
    String imageUrl =
        supabase.storage.from('bucket_fotos').getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    onUpload(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: imageUrl != null
              ? Image.network(
                  height: size,
                  width: size,
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey,
                  child: Image.asset('images/nophoto.png', height: size),
                ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    imageQuality: quality);
                if (image == null) {
                  return;
                }
                _recuperaFoto(image);
              },
              child: const Text('Galeria'),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    imageQuality: quality);
                if (image == null) {
                  return;
                }
                _recuperaFoto(image);
              },
              child: const Text('Câmera'),
            ),
          ],
        ),
      ],
    );
  }
}
