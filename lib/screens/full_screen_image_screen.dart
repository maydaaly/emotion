import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/downloaded_image.jpg';

        await Dio().download(imageUrl, filePath);

        // Save the image to the gallery
        await GallerySaver.saveImage(filePath).then((success) {
          if (success != null && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image saved to photos')),
            );
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
