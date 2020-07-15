import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();

  String _signedMessage;

  @override
  void initState() {
    super.initState();
    final htmlString = Uri.dataFromString(
            '<script src="https://cdn.jsdelivr.net/npm/web3@latest/dist/web3.min.js"></script><html><body>hello world</body></html>',
            mimeType: 'text/html')
        .toString();
    _flutterWebviewPlugin.launch(htmlString, withJavascript: true, hidden: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JS script example"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Type message'),
                controller: _textEditingController,
              ),
              const SizedBox(height: 24),
              RaisedButton(
                onPressed: () => _signMessage(),
                child: Text("Sign message"),
              ),
              const SizedBox(height: 24),
              Text(_signedMessage ?? "")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signMessage() async {
    try {
      var givenJS = await rootBundle.loadString('assets/example.js');
      givenJS = givenJS.replaceAll("test_message", _textEditingController.value.text);

      _signedMessage = await _flutterWebviewPlugin.evalJavascript(givenJS);
      print("Test -> $_signedMessage");
      setState(() {});
    } catch (e) {
      print("Error -> $e");
      print(e.toString());
    }
  }
}
