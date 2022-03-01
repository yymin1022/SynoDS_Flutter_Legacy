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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: const StatusView()
              ),
              Container(
                child: const TaskView()
              )
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
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Container(
              color: Color(0xFFDDDDDD),
              height: 100,
              width: 160,
              margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              )

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Text("$_download"),
                  Text("KB/s")
                ]
              )
            ),
            Container(
              color: Color(0xFFDDDDDD),
              height: 100,
              width: 160,
              margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              )

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Text("$_upload"),
                  Text("KB/s")
                ]
              )
            )
          ]
        )
      ],
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
    return Column(
      children: <Widget>[
        Text("$_taskTitle")
      ],
    );
  }
}