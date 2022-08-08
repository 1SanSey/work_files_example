import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Local file read/write Demo',
      home: ReadWriteFileExample(),
    );
  }
}

class ReadWriteFileExample extends StatefulWidget {
  const ReadWriteFileExample({Key? key}) : super(key: key);
  @override
  State<ReadWriteFileExample> createState() => _ReadWriteFileExampleState();
}

class _ReadWriteFileExampleState extends State<ReadWriteFileExample> {
  final TextEditingController _textController = TextEditingController();
  static String kLocalFileName = 'demo_localfile.txt';
  String _localFileContent = '';
  String _localFilePath = kLocalFileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readTextFromLocalFile();
    _getLocalFile.then((file) => setState(() => _localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local file read/write Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const Text('Write to local file:', style: TextStyle(fontSize: 20)),
          TextField(
              focusNode: textFieldFocusNode,
              controller: _textController,
              maxLines: null,
              style: const TextStyle(fontSize: 20)),
          ButtonBar(
            children: <Widget>[
              MaterialButton(
                child: const Text('Load', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  _readTextFromLocalFile();
                  _textController.text = _localFileContent;
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log('This file successfuly loaded');
                },
              ),
              MaterialButton(
                child: const Text('Save', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  await _writeTextToLocalFile(_textController.text);
                  _textController.clear();
                  await _readTextFromLocalFile();
                  log('This file successfuly written');
                },
              ),
            ],
          ),
          const Divider(height: 20.0),
          Text('Local file path:',
              style: Theme.of(context).textTheme.headline6),
          Text(_localFilePath, style: Theme.of(context).textTheme.subtitle1),
          const Divider(height: 20.0),
          Text('Local file content:',
              style: Theme.of(context).textTheme.headline6),
          Text(_localFileContent, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/$kLocalFileName');
  }

  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch (e) {
      content = 'File upload error: $e';
    }
    setState(() {
      _localFileContent = content;
    });
  }

  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }
}
