import 'package:flutter/material.dart';

import 'package:syno_downlaodstation/utils/api_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late FocusNode urlFocusNode;
  late FocusNode idFocusNode;
  late FocusNode pwFocusNode;
  late FocusNode otpFocusNode;

  String url = "";
  String idValue = "";
  String pwValue = "";
  String otpValue = "";

  bool apiAuthExist = false;
  bool dsInfoExist = false;
  bool dsTaskExist = false;
  bool dsStatisticExist = false;

  Map? tempAPIList;
  final Map<String, String> tempSession = {
    'account': '',
    'sid': ''
  };

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
      Map result = await requestAPI(url, 'SYNO.API.Info', {
        'method': 'query',
        'query': 'SYNO.API.Auth,SYNO.DownloadStation.Info,SYNO.DownloadStation.Task,SYNO.DownloadStation.Statistic'
      });
      if (result['req_success']) {
        if (result['payload']['success']) {
          // on Synology Success Bool
          if (apiUsable(result['payload']['data'])) {
            // All Ok
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
    Map result = await requestAPITest(url, 'SYNO.API.Auth', tempAPIList!['SYNO.API.Auth'], {
      'method': 'login',
      'account': idValue,
      'passwd': pwValue,
      'session': 'DownloadStation',
      'format': 'sid',
      if (otpValue.toString() != '') 'otp_code': otpValue
    });
    print(result);
    if (result['req_success']) {
      final payload = result['payload'];
      if (result['payload']['success']) {
        // on Synology Success Bool
        tempSession['sid'] = payload['data']['sid'];
        tempSession['account'] = payload['data']['account'];
        return 0;
      } else {
        return payload['error']['code'];
      }
    }
    return -1;
  }

  Future<int> _fetchData(BuildContext context, [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
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
        // OK API
        int loginCode = await loginTask();
        if (loginCode == 0) {
          print('ALL OK');
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
  }

  @override
  void dispose() {
    urlFocusNode.dispose();
    super.dispose();
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
                              // clipBehavior: Clip.antiAlias,
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
                                              url = 'https://$value'
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
                              // clipBehavior: Clip.antiAlias,
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
                                            onChanged: (value) => {
                                              otpValue = value
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                                    child: Row(
                                      children: [
                                        const Text('Auto Login', style: TextStyle(fontSize: 16),),
                                        Switch(
                                          value: autoLogin,
                                          activeColor: Colors.red,
                                          onChanged: (bool value) {
                                            setState(() {
                                              autoLogin = value;
                                            });
                                          },
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
                                _fetchData(context).then((loginCode) {
                                  print(loginCode);
                                  if (loginCode == 0) {
                                    print(tempAPIList);
                                    print(tempSession);
                                    setAPIList(tempAPIList!);
                                    serverManager.setSessionInfo(tempSession['account']!, 'kk', tempSession['sid']!);
                                    serverManager.setLogin(true);
                                    serverManager.setURL(url);
                                    Navigator.of(context).pop(true);
                                  } else {
                                    serverManager.setLogin(false);
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false, // user must tap button!
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
                                });
                              },
                              child: const Text('Connect')
                            ),
                          ),
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