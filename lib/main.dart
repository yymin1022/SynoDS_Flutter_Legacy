import 'dart:async';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/task_listview_data.dart';
import 'model/task_raw.dart';
import 'routes/connect_page.dart';
import 'routes/setting_page.dart';
import 'utils/api_helper.dart';
import 'utils/session_manager.dart';
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
  SessionManager serverManager = SessionManager();
  Color bottomColor = Colors.white;
  bool logined = false;
  bool alertBool = false;
  String alertValue = '';
  List<TaskListData> rawTasks = [];
  int entireUploadSpeed = 0;
  int entireDownloadSpeed = 0;

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
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      print('로그인 여부 : $logined');
      if (logined) {
        hideAlert();
        final result = await requestAPI('https://${serverManager.getURL()}', 'SYNO.DownloadStation.Task', {
          'method': 'list',
          'additional': 'detail,transfer',
          '_sid': serverManager.getSid()
        });
        var mTask = TaskRaw.fromJson(result['payload']);
        if (mTask.data != null) {
          rawTasks.clear();
          entireUploadSpeed = 0;
          entireDownloadSpeed = 0;
          for (var eTask in mTask.data!.tasks!) {
            final taskSize = eTask.size!;
            final downloadedSize = eTask.additional!.transfer!.sizeDownloaded!;
            final rawProgress = downloadedSize / taskSize;
            late double progress;
            if (rawProgress.isInfinite || rawProgress.isNaN) {
              progress = 0;
            } else {
              progress = rawProgress;
            }
            final uploadSpeed = eTask.additional!.transfer!.speedUpload!;
            final downloadSpeed = eTask.additional!.transfer!.speedDownload!;
            entireUploadSpeed += uploadSpeed;
            entireDownloadSpeed += downloadSpeed;
            rawTasks.add(TaskListData(
                title: eTask.title!,
                status: eTask.status!,
                taskSize: filesize(taskSize),
                downloadedSize: filesize(downloadedSize),
                progress: progress,
                uploadSpeed: '${filesize(uploadSpeed)}/s',
                downloadSpeed: '${filesize(downloadSpeed)}/s'
            ));
          }
          setState(() {
            rawTasks;
            entireUploadSpeed;
            entireDownloadSpeed;
          });
        }
      } else {
        showAlert('연결된 서버가 없습니다.');
      }
    });
    directConnect();
  }

  void directConnect() async {
    final prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    var a = prefs.getBool('auto_login');
    var b = prefs.getBool('require_otp');
    var c = prefs.getString('server_url');
    var d = await storage.read(key: 'server_id');
    var e = await storage.read(key: 'server_pw');
    if (a ?? false) {
      if (b != null) {
        if (b == false) {
          if (!mounted) return;
          final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(initStatus: {
                'url': c,
                'id': d,
                'pw': e
              }))
          );
          logined = logined ? true : result;
        }
      }
    }
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