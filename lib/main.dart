import 'package:flutter/material.dart';
import 'model/task_listview_data.dart';
import 'routes/connect_page.dart';
import 'routes/setting_page.dart';
import 'widget/main_status_widget.dart';
import 'widget/main_alert_widget.dart';
import 'widget/task_listview_widget.dart';

void main() {
  runApp(const DSApp());
}

class DSApp extends StatelessWidget {
  const DSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synology DS',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ServerDetailPage(),
    );
  }
}

class ServerDetailPage extends StatefulWidget {
  const ServerDetailPage({super.key});

  @override
  State<ServerDetailPage> createState() => ServerDetailPageState();
}

class ServerDetailPageState extends State<ServerDetailPage> {
  Color bottomColor = Colors.white;
  bool logined = true;
  bool alertBool = false;
  String alertValue = '';
  List<TaskListData> rawTasks = [
    TaskListData(
        title: 'Task 1 (Long Task Name, Long Task Name)',
        status: 'waiting',
        taskSize: '1.0 GB',
        downloadedSize: '0.0 B',
        progress: 0,
        uploadSpeed: '0 B/s',
        downloadSpeed: '0 B/s'
    ),
    TaskListData(
        title: 'Task 2',
        status: 'downloading',
        taskSize: '1.0 GB',
        downloadedSize: '250 MB',
        progress: 0.25,
        uploadSpeed: '10 MB/s',
        downloadSpeed: '10 MB/s'
    ),
    TaskListData(
        title: 'Task 3',
        status: 'paused',
        taskSize: '1.0 GB',
        downloadedSize: '500 MB',
        progress: 0.5,
        uploadSpeed: '0 B/s',
        downloadSpeed: '0 B/s'
    ),
    TaskListData(
        title: 'Task 4',
        status: 'error',
        taskSize: '1.0 GB',
        downloadedSize: '750 MB',
        progress: 0.75,
        uploadSpeed: '0 B/s',
        downloadSpeed: '0 B/s'
    ),
    TaskListData(
        title: 'Task 5',
        status: 'finished',
        taskSize: '1.0 GB',
        downloadedSize: '1.0 GB',
        progress: 1.0,
        uploadSpeed: '0 B/s',
        downloadSpeed: '0 B/s'
    ),
  ];
  int entireUploadSpeed = 10240000;
  int entireDownloadSpeed = 10240000;

  void showAlert(String val) {
    setState(() {
      alertBool = true;
      alertValue = val;
    });
  }

  void hideAlert() {
    setState(() {
      alertBool = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!logined) showAlert('연결된 서버가 없습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bottomColor,
      appBar: AppBar(
        title: const Text('Synology DS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.key),
            tooltip: 'Info',
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())
              );
              logined = logined ? true : result;
            },
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Clean Task',
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Task',
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingPage()
                  )
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: alertBool ? MainAlertWidget(
                  key: const Key("loading"),
                  alertValue: alertValue,
                ) : MainStatusWidget(
                  key: const Key("normal"),
                  uploadSpeed: entireUploadSpeed,
                  downloadSpeed: entireDownloadSpeed,
                ),
              ),
              const Divider(
                thickness: 2,
                height: 1,
                color: Color(0xFFEEEEEE),
              ),
              TaskListWidget(rawTasks: rawTasks),
              const Divider(
                thickness: 2,
                height: 1,
                color: Color(0xFFEEEEEE),
              ),
              Row(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: bottomColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle, size: 12, color: logined ? Colors.green : Colors.red),
                                const SizedBox(width: 10,),
                                Text(
                                    'Server ${logined ? 'Connected' : 'Disconnected'}',
                                    style: TextStyle(color: logined ? Colors.green : Colors.red, fontWeight: FontWeight.bold)
                                )
                              ],
                            ),
                            Text('${rawTasks.length} Tasks')
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      /*
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 52),
        child: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'add',
          child: const Icon(Icons.add),
        ),
      ),
      */
    );
  }
}