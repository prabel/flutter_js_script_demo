import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

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

  String _signedMessage;
  JSContext _jsContext;

  @override
  void initState() {
    super.initState();
    _jsContext = JSContext.createInGroup();
  }

  @override
  void dispose() {
    _jsContext.release();
    _textEditingController.dispose();
    super.dispose();
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
      _signedMessage = _jsContext.evaluate(givenJS).string;
      print("Test -> $_signedMessage");
      setState(() {});
    } catch (e) {
      print("Error -> $e");
      print(e.toString());
    }
  }
}
