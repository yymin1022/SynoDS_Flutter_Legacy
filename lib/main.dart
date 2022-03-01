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
            children: [
              const StatusView()
            ]
          )
        )
      )
    );
  }
}

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  int _download = 0;
  int _upload = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var _taskDownload = "12.5";
  var _taskPercentage = "15";
  var _taskSize = "20.0";
  var _taskTitle = "Test Task";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
        ],
      )
    );
  }
}