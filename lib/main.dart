import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> _callingThisMethodFromSwift(MethodCall call) async {
  switch (call.method) {
    case 'my_method':
      // Do something
      final Map arguments = call.arguments;
      final String arg1 = arguments['Nepal'];
      final String arg2 = arguments['UK'];
      print(arg1);
      print(arg2);

      print("\nOur Native iOS code is calling Flutter method/!!");
      return "Awesome!!";
      // break;
    default:
      throw PlatformException(
        code: 'Unimplemented',
        details: 'Method ${call.method} not implemented',
      );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MethodChannel channel = const MethodChannel('my_channel');
  channel.setMethodCallHandler(_callingThisMethodFromSwift);
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter MethodChannel Demo',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // methodchannel name can be anything you like
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'Battery Level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    Map data = {
      "Nepal": "The capital city of Nepal is Kathmandu.",
      "UK": "The capital city of UK is London."
    };
    try {
      // here also you can name your method anything you like
      final int result = await platform.invokeMethod('getBatteryLevel', data);
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("Method Channel"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.yellow),
              ),
              onPressed: () {
                _getBatteryLevel();
              },
              child: const Text(
                'Get Battery Level',
                style: TextStyle(color: Colors.black),
              ),
            ),

            // To show battery percentage.
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}
