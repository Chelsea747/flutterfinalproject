import 'package:flutter/material.dart';

class FullScreenPage extends StatelessWidget {
  final Image child;
  const FullScreenPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(child: Center(child: child)),
          Positioned(
            left: 24,
            top: 24,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
