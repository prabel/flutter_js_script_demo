import 'package:flutter/material.dart';
import 'package:flutter_liquidcore/liquidcore.dart';

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
      var givenJS = '''
          async function js_function(message) {
            var Web3 = await require('web3');
            var web3 = new Web3();
            var account = web3.eth.accounts.create();
            var signedMessage = web3.eth.accounts.sign("asdasd", account.privateKey);
            return signedMessage;
          }
          
          js_function('test_message');
      ''';
//      givenJS = givenJS.replaceAll("test_message", _textEditingController.value.text);

      _jsContext = JSContext();
      final response = await _jsContext.evaluateScript(givenJS);
      print("Test -> $response");
      setState(() {});
    } catch (e) {
      print("Error -> $e");
      print(e.toString());
    }
  }
//
//  Future<void> test()async {
//    _microService = MicroService(uri);
//    await _microService.addEventListener('ready',
//                    (service, event, eventPayload) {
//              // The service is ready.
//              if (!mounted) {
//                return;
//              }
//              //_emit();
//            });
//    await _microService.addEventListener('pong',
//                    (service, event, eventPayload) {
//              if (!mounted) {
//                return;
//              }
//
//              _setMicroServiceResponse(eventPayload['message'] as String);
//            });
//    await _microService.addEventListener('object',
//                    (service, event, eventPayload) {
//              if (!mounted) {
//                return;
//              }
//
//              print("received obj: $eventPayload | type: ${eventPayload.runtimeType}");
//            });
//
//    // Start the service.
//    await _microService.start();
//  }
}
