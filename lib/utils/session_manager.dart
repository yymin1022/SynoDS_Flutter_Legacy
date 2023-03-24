class SessionManager {

  SessionManager._privateConstructor();
  static final SessionManager _instance = SessionManager._privateConstructor();
  factory SessionManager() { return _instance; }

  String _serverUrl = '';
  bool _isLogin = false;
  final Map<String, String> _sessionData = {
    'account': '',
    'device_id': '',
    'sid': ''
  };

  setURL(String url) { _serverUrl = url; }
  setLogin(bool val) { _isLogin = val; }
  setAccount(String val) { _sessionData['account'] = val; }
  setDeviceId(String val) { _sessionData['device_id'] = val; }
  setSid(String val) { _sessionData['sid'] = val; }
  setSessionInfo(String mAccount, String mDID, String mSID) {
    _sessionData['account'] = mAccount;
    _sessionData['mDID'] = mDID;
    _sessionData['sid'] = mSID;
  }

  getURL() { return _serverUrl; }
  getLogin() { return _isLogin; }
  getAccount() { return _sessionData['account']; }
  getDeviceId() { return _sessionData['device_id']; }
  getSid() { return _sessionData['sid']; }
  getSessionInfo() { return _sessionData; }
}