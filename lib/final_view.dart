import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'image_select.dart';

class  SavingView extends StatelessWidget {
  const SavingView({super.key, required this.file, required this.filename});

    final File file;
    final String filename;

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Image Saved'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image(
                image: file.existsSync() ? FileImage(file) : AssetImage('assets/images/error.png') as ImageProvider,
                height: 150,
            ),
            const SizedBox(height: 16),
            const Text('Image encoded successfully!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                // Handle Save image logic
                final String? filepath = await FileSelect.selectSaveLocation(file, filename);
                if (filepath == null) {
                    dev.log('Saving cancelled');
                    return;    
                }
                dev.log('Saving image at path: $filepath');
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => ImageView(imagePath: file.path)),
                // );
                },
                child: const Text('Save Image'),
            ),
            ],
        ),
        ),
    );
    }
}

class  DecodedView extends StatelessWidget {
  const DecodedView({super.key, required this.file, required this.message, required this.filename});

    final File file;
    final String message;
    final String filename;

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Image Saved'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image(
                image: file.existsSync() ? FileImage(file) : AssetImage('assets/images/error.png') as ImageProvider,
                height: 150,
            ),
            const SizedBox(height: 16),
            const Text('Image decoded successfully!', style: TextStyle(fontSize: 18)),
            Text(message, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ],
        ),
        ),
    );
    }
}