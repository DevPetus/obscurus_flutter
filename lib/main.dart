import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'stegano.dart';

import 'final_view.dart';
import 'image_select.dart';

void main() {
  runApp(const Obscurus());
}

class Obscurus extends StatelessWidget {
  const Obscurus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obscurus',
      home: Builder(
        builder: (context) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Column(
                    children: [
                      //Logo
                      Center(
                        heightFactor: 1.1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset('assets/images/logo.jpg'),
                        ),
                      ),

                      //Title
                      Center(
                        child: const Text(
                          'Obscurus',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      //Subtitle
                      Center(child: const Text('Steganography made easy')),
                    ],
                  ),
                ),

                //Action buttons
                Expanded(
                  child: Row(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.blue,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // Handle button press
                            String? image = await FileSelect.selectImage();
                            dev.log('Image selected: $image');

                            if (image != null && context.mounted) {
                              dev.log(
                                'Navigating to EncodingWidget with image: $image',
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EncodingWidget(imagePath: image),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Encode',
                            textScaler: TextScaler.linear(3.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 179, 100, 10),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // Handle button press
                            String? image = await FileSelect.selectImage();
                            dev.log('Image selected: $image');

                            if (image != null && context.mounted) {
                              dev.log(
                                'Navigating to DecodingWidget with image: $image',
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DecodingWidget(imagePath: image),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Decode',
                            textScaler: TextScaler.linear(3.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EncodingWidget extends StatelessWidget {
  const EncodingWidget({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    String message = '';

    return Scaffold(
      appBar: AppBar(title: const Text('Encoding')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: (value) => message = value,
              onChanged: (value) => message = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter message to encode',
              ),
              minLines: 3,
              maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                dev.log('Message submitted "$message"');
                //Get image name from path
                String filename = imagePath.split('/').last;


                // Loading animation will go here, for now just go to saving view @TODO
                Stegano.encode(message, imagePath).then((file) {
                  if (file != null) {
                    dev.log('Image encoded successfully: ${file.path}');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SavingView(file: file, filename: filename),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image encoded successfully!'),
                      ),
                    );
                  } else {
                    dev.log('Failed to encode image');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to encode image.')),
                    );
                  }
                });
              },
              child: const Text('Encode'),
            ),
          ],
        ),
      ),
    );
  }
}

class DecodingWidget extends StatelessWidget {
  const DecodingWidget({super.key, required this.imagePath});

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    String message = '';

    final File file = File(imagePath);
    return Scaffold(
      appBar: AppBar(title: const Text('Decoding')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(file, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            // @TODO Secret for decoding
            // TextField(
            //   onSubmitted: (value) => message = value,
            //   onChanged: (value) => message = value,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: 'Enter secret to decode',
            //   ),
            //   minLines: 3,
            //   maxLines: null,
            // ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Decode'),
              onPressed: () {
                dev.log('Message submitted "$message"');
                //Get image name from path
                String filename = imagePath.split('/').last;


                // Loading animation will go here, for now just go to saving view @TODO
                Stegano.decode(imagePath).then((message) {
                  if (message != null) {
                    dev.log('Image decoded successfully: $message');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DecodedView(file : file, message: message, filename: filename),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image decoded successfully!'),
                      ),
                    );
                  } else {
                    dev.log('Failed to decode image');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to decode image.')),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
