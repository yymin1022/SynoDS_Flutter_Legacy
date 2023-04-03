import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syno_downlaodstation/utils/api_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.initStatus});
  final Map? initStatus;

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // 입력 컴포넌트 포커스 제어를 위한 노드
  late FocusNode urlFocusNode;
  late FocusNode idFocusNode;
  late FocusNode pwFocusNode;
  late FocusNode otpFocusNode;

  // TextField Value
  String url = "";
  String idValue = "";
  String pwValue = "";
  String otpValue = "";

  // TextField Controller
  TextEditingController urlStrController = TextEditingController(text: "");
  TextEditingController idStrController = TextEditingController(text: "");
  TextEditingController pwStrController = TextEditingController(text: "");

  // 연결 시 유효한 연결정보를 담을 변수
  Map? tempAPIList;
  final Map<String, String> tempSession = {
    'account': '',
    'sid': ''
  };

  // 자동로그인 여부
  bool autoLogin = false;

  static const Map<int, String> errorType = {
    -2: 'Timeout',
    400: 'Invalid account or Incorrect Password',
    401: 'disable Account',
    402: 'not have Permission',
    403: 'Require OTP Code',
    404: 'Incorrect OTP Code',
    407: 'IP district'
  };

  Future<bool> fetchAPITask() async {
    tempAPIList = null;
    if (apiExist('SYNO.API.Info')) {
      Map result = await requestAPI('https://$url', 'SYNO.API.Info', {
        'method': 'query',
        'query': 'SYNO.API.Auth,SYNO.DownloadStation.Info,SYNO.DownloadStation.Task,SYNO.DownloadStation.Statistic'
      });
      if (result['req_success']) {
        if (result['payload']['success']) {
          if (apiUsable(result['payload']['data'])) {
            tempAPIList = result['payload']['data'];
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<int> loginTask() async {
    if (tempAPIList!['SYNO.API.Auth'] == null) return -1;
    Map result = await requestAPITest('https://$url', 'SYNO.API.Auth', tempAPIList!['SYNO.API.Auth'], {
      'method': 'login',
      'account': idValue,
      'passwd': pwValue,
      'session': 'DownloadStation',
      'format': 'sid',
      if (otpValue.toString() != '') 'otp_code': otpValue
    });
    if (result['req_success']) {
      final payload = result['payload'];
      if (result['payload']['success']) {
        tempSession['sid'] = payload['data']['sid'];
        tempSession['account'] = payload['data']['account'];
        return 0;
      } else {
        return payload['error']['code'];
      }
    }
    return -1;
  }

  Future<int> _fetchData(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text('연결중...')
                ],
              ),
            ),
          );
        }
    );

    Future<int> task() async {
      if (await fetchAPITask()) {
        // API OK
        int loginCode = await loginTask();
        if (loginCode == 0) {
          return 0;
        } else {
          return loginCode;
        }
      } else {
        // Unavailable API
        return -1;
      }
    }

    int result = await task().timeout(const Duration(seconds: 30), onTimeout: () => -2);

    if (!mounted) return 0;
    Navigator.of(context).pop();
    return result;
  }

  @override
  void initState() {
    super.initState();
    urlFocusNode = FocusNode();
    idFocusNode = FocusNode();
    pwFocusNode = FocusNode();
    otpFocusNode = FocusNode();
    if (widget.initStatus != null) {
      url = widget.initStatus?['url'];
      idValue = widget.initStatus?['id'];
      pwValue = widget.initStatus?['pw'];
      autoLogin = true;
      urlStrController.text = url;
      idStrController.text = idValue;
      pwStrController.text = pwValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchData(context).then(loginProcess);
      });
    }
  }

  @override
  void dispose() {
    urlFocusNode.dispose();
    super.dispose();
  }

  void loginProcess(int loginCode) async {
    if (loginCode == 0) {
      setAPIList(tempAPIList!);
      serverManager.setSessionInfo(tempSession['account']!, 'kk', tempSession['sid']!);
      serverManager.setLogin(true);
      serverManager.setURL(url);

      // ALL OK
      final prefs = await SharedPreferences.getInstance();
      const storage = FlutterSecureStorage();
      await prefs.setBool('auto_login', autoLogin);
      await prefs.setBool('require_otp', otpValue != '');
      await prefs.setString('server_url', url);
      await storage.write(key: 'server_id', value: idValue);
      await storage.write(key: 'server_pw', value: pwValue);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } else {
      serverManager.setLogin(false);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errorType[loginCode] ?? 'Unknown Error'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        urlFocusNode.unfocus();
        idFocusNode.unfocus();
        pwFocusNode.unfocus();
        otpFocusNode.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.pop(context, false),
            ),
            title: const Text('Connect')
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ListTile(
                                    leading: Icon(Icons.domain, size: 48),
                                    title: Text('Server Address'),
                                    subtitle: Text('서버주소를 입력해주세요'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lock, color: Colors.green,),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          child: TextField(
                                            controller: urlStrController,
                                            style: const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              prefixText: 'https://',
                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(),
                                              filled: false,
                                              labelText: 'URL',
                                            ),
                                            focusNode: urlFocusNode,
                                            onChanged: (value) => {
                                              url = value
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ListTile(
                                    leading: Icon(Icons.key, size: 48),
                                    title: Text('Account'),
                                    subtitle: Text('계정정보를 입력해주세요'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: idStrController,
                                          style: const TextStyle(fontSize: 16),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            border: OutlineInputBorder(),
                                            filled: false,
                                            labelText: 'ID',
                                          ),
                                          focusNode: idFocusNode,
                                          onChanged: (value) => {
                                            idValue = value
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 24),
                                          child: TextField(
                                            controller: pwStrController,
                                            obscureText: true,
                                            style: const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(),
                                              filled: false,
                                              labelText: 'Password',
                                            ),
                                            focusNode: pwFocusNode,
                                            onChanged: (value) => {
                                              pwValue = value
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 24),
                                          child: TextField(
                                            obscureText: false,
                                            style: const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(),
                                              filled: false,
                                              labelText: 'OTP (Optional)',
                                            ),
                                            focusNode: otpFocusNode,
                                            onChanged: (value) {
                                              setState(() {
                                                otpValue = value;
                                                if (otpValue != '') autoLogin = false;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                                    child: Text('자동로그인은 OTP 사용시 비활성화됩니다', style: TextStyle(color: Colors.red),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                    child: Row(
                                      children: [
                                        const Text('Auto Login', style: TextStyle(fontSize: 16),),
                                        Switch(
                                          value: autoLogin,
                                          activeColor: Colors.red,
                                          onChanged: otpValue == '' ? (bool value) {
                                            setState(() {
                                              autoLogin = value;
                                            });
                                          } : null,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: ElevatedButton(
                              onPressed: () {
                                _fetchData(context).then(loginProcess);
                              },
                              child: const Text('Connect')
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                /*
                                final prefs = await SharedPreferences.getInstance();
                                const storage = FlutterSecureStorage();
                                var a = prefs.getBool('auto_login');
                                var b = prefs.getBool('require_otp');
                                var c = prefs.getString('server_url');
                                var d = await storage.read(key: 'server_id');
                                var e = await storage.read(key: 'server_pw');
                                */
                              },
                              child: const Text('Debug'),
                            ),
                          )
                        ],
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}