import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // a unique file name for each image
        Directory tempDir = await getTemporaryDirectory();
        String fileName = path.basename(imageUrl);
        String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
        String filePath = '${tempDir.path}/$uniqueFileName';

        await Dio().download(imageUrl, filePath);

        // Save the image to the gallery and trigger a media scan
        await GallerySaver.saveImage(filePath).then((success) {
          if (success != null && success) {
            File(filePath).stat().then((fileStat) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image saved to photos')),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save image to photos')),
            );
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading image: $e')),
        );
      }
    } else {
      // If permission is not granted, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full-size Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => downloadImage(context, imageUrl),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
