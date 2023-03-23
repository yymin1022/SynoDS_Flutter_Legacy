import 'package:flutter/material.dart';

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

  bool autoLogin = false;

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