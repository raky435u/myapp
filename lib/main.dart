import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/components/sign_in_up_form.dart';
import 'package:myapp/styles/app_theme.dart';

// Simple data structure for a crop listing
class Crop {
  final String name;
  final double pricePerUnit;
  final String unit; // e.g., "kg", "dozen"
  final int availableQuantity;

  String? category;

  String? consumerDescription;

  Crop({
    required this.name,
    required this.pricePerUnit,
    required this.unit,
    required this.availableQuantity,
  });
}

void main() {
  runApp(const MyApp());
}

class CropProvider with ChangeNotifier {
  final List<Crop> _availableCrops = [];

  List<Crop> get availableCrops => _availableCrops;

  void addCrop(Crop crop) {
    _availableCrops.add(crop);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            farmersComponent(),
            consumersComponent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  consumersComponent() {}
}

farmersComponent() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CropProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        home: SignInUpForm(onSignInUpSuccess: () {}),
      ),
    );
  }
}
