
import 'package:flutter/material.dart';
import 'package:texture_and_native_view/presentation/widgets/custom_native_view_widget.dart';
import 'package:texture_and_native_view/presentation/widgets/custom_texture_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showTexture = false;

  bool showNativeView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Texture And Native View",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => showTexture = !showTexture),
              child: Visibility(
                visible: showTexture,
                replacement: Center(
                  child: Text(
                    "Play Texture",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                child: const CustomTextureWidget(),
              ),
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => showNativeView = !showNativeView),
              child: Visibility(
                visible: showNativeView,
                replacement: Center(
                  child: Text(
                    "Play Native View",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                child: CustomNativeViewWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



