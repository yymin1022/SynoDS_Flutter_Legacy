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
              child: Column(children: [
                const StatusItem()
              ])
            ]))));
  }
}

class StatusItem extends StatefulWidget {
  const StatusItem({Key? key}) : super(key: key);

  @override
  State<StatusItem> createState() => _StatusItemState();
}

class _StatusItemState extends State<StatusItem> {
  int _download = 0;
  int _upload = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: [
                  Text("$_download"),
                  Text("KB/s")
                ]
              ),
              Column(
                children: [
                  Text("$_upload"),
                  Text("KB/s")
                ]
              )
            ]
          )
        ],
      )
    );
  }
}
