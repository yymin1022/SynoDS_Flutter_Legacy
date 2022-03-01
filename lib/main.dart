import "package:flutter/material.dart";

void main() {
  runApp(const DSApp());
}

class DSApp extends StatelessWidget {
  const DSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SynoDS",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("SynoDS"),
        ),
        body: Center(
          child: Column(
            Row(
              children: [
                Text("Upload DATA"),
                Text("Download DATA")
              ]
            ),
            Column(
              children: [
                Text("Task 1"),
                Text("Task 2"),
                Text("Task 3"),
                Text("Task 4")
              ]
            )
          )
        )
      )
    );
  }
}

class DSHomePage extends StatefulWidget {
  const DSHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DSHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DSHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "You have pushed the button this many times:",
            ),
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
