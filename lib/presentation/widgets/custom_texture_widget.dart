import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CustomTextureWidget extends StatefulWidget {
  const CustomTextureWidget({super.key});

  @override
  State<CustomTextureWidget> createState() => _CustomTextureWidgetState();
}

class _CustomTextureWidgetState extends State<CustomTextureWidget> {
  static const _channel = MethodChannel("com.example.texture_and_native_view");

  Future<int> _fetchTextureId() async {
    final videoAsset = await rootBundle.load("assets/video-example.mp4");

    final path = (await getTemporaryDirectory()).path;
    final videoPath = "$path/video-example.mp4";

    final file = await File(
      videoPath,
    ).writeAsBytes(videoAsset.buffer.asUint8List());

    return _channel
        .invokeMethod<int>("getTextureId", file.path)
        .then((value) => value ?? -1);
  }

  @override
  void dispose() {
    super.dispose();
    _channel.invokeMethod("closeTextureView");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _fetchTextureId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.lightBlue),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro: ${snapshot.error}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          );
        }

        final textureId = snapshot.data;
        if (textureId == null || textureId < 0) {
          return const Center(
            child: Text(
              'Não foi possível obter a textura.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        return Stack(
          children: [
            Positioned.fill(child: Texture(textureId: textureId)),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                color: Colors.black.withOpacity(.9),
                child: Text(
                  "Texture ID: $textureId",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
