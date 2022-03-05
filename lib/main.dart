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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_album),
                  tooltip: "Settings",
                  onPressed: () => {},
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  tooltip: "Info",
                  onPressed: () => {},
                )
              ]
            ),
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(child: const StatusView()),
                  Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
                  Container(child: const TaskView())
                ]))));
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
                  height: 100,
                  width: 160,
                  margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFFDDDDDD),
                        width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$_download", style: TextStyle(fontSize: 35)),
                        Text("KB/s", style: TextStyle(fontSize: 15))
                      ])),
              Container(
                  height: 100,
                  width: 160,
                  margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFFDDDDDD),
                        width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$_upload", style: TextStyle(fontSize: 35)),
                        Text("KB/s", style: TextStyle(fontSize: 15))
                      ]))
            ])
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      
      child: Column(
        children: <Widget>[
          TaskViewItem(new TaskData("Test Task 1", "TaskID", 12.5)),
          TaskViewItem(new TaskData("Test Task 2", "TaskID", 22.3)),
          TaskViewItem(new TaskData("Test Task 3", "TaskID", 100)),
          TaskViewItem(new TaskData("Test Task 4", "TaskID", 0.5)),
        ],
      )
    );
  }
}

class TaskData {
  double percentage;
  String title;
  String taskID;

  TaskData(this.title, this.taskID, this.percentage);
}

class TaskViewItem extends StatelessWidget {
  TaskViewItem(this._task);
  final TaskData _task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(_task.title),
        subtitle: Text("${_task.percentage}%"),
        trailing: Text("${_task.taskID}"));
  }
}
