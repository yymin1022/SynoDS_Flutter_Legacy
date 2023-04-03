import 'package:flutter/material.dart';
import 'package:syno_downlaodstation/utils/session_manager.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {

  SessionManager sessionManager = SessionManager();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    isLogin = sessionManager.getLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Setting')
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: ElevatedButton(
                    onPressed: isLogin ? () {

                    } : null,
                    child: const Text('Logout')
                ),
              ),
            ],
          ),
        )
    );
  }
}