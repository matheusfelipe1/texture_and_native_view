import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CustomNativeViewWidget extends StatefulWidget {
  const CustomNativeViewWidget({super.key});

  @override
  State<CustomNativeViewWidget> createState() => CustomNativeViewWidgetState();
}

class CustomNativeViewWidgetState extends State<CustomNativeViewWidget> {
  final nativeViewFactoryName = "com.example.native_view_factory_name";

  Future<String> _getFile() async {
    final videoAsset = await rootBundle.load("assets/video-example.mp4");

    final path = (await getTemporaryDirectory()).path;
    final videoPath = "$path/video-example.mp4";

    final file = await File(
      videoPath,
    ).writeAsBytes(videoAsset.buffer.asUint8List());

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getFile(),
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

        final path = snapshot.data;
        if (path == null || path.isEmpty) {
          return const Center(
            child: Text(
              'Não foi possível obter a url do arquivo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        return IgnorePointer(
          ignoring: true,
          child: Platform.isAndroid
              ? AndroidView(
                creationParams: {"path": path},
                viewType: nativeViewFactoryName,
                layoutDirection: TextDirection.ltr,
                creationParamsCodec: const StandardMessageCodec(),
              )
              : UiKitView(
                creationParams: {"path": path},
                viewType: nativeViewFactoryName,
                layoutDirection: TextDirection.ltr,
                creationParamsCodec: const StandardMessageCodec(),
              ),
        );
      },
    );
  }
}
