import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syno_downlaodstation/utils/session_manager.dart';

SessionManager serverManager = SessionManager();
Map _apiList = {
  'SYNO.API.Info': {
    'maxVersion': 1,
    'minVersion': 1,
    'path': 'query.cgi'
  }
};

void setAPIList(Map m) {
  _apiList = {
    'SYNO.API.Info': {
      'maxVersion': 1,
      'minVersion': 1,
      'path': 'query.cgi'
    }, ...m
  };
}

Map getAPIList() {
  return _apiList;
}

Map getAPI(String apiName) {
  return _apiList[apiName];
}

/*
요약 : fetch한 API 목록에 해당 API가 존재하는지 확인하는 함수
매개변수 : 확인할 API 이름
 */
bool apiExist(String apiName) {
  final temp = _apiList[apiName];
  if (temp != null) {
    if (temp['maxVersion'] != null && temp['path'] != null) {
      return true;
    }
  }
  return false;
}

/*
요약 : fetch 후 저장된 API 데이터를 기반으로 API를 호출하는 함수
매개변수 : base url, 호출할 API 이름, 전달할 매개변수
 */
Future<Map<String, dynamic>> requestAPI(String url, String apiName, Map param) async {
  Map api = getAPI(apiName);
  int maxVersionValue = api['maxVersion'];
  String pathValue = api['path'];
  print('API 요청 : $url/webapi/$pathValue');
  final mUrl = Uri.parse('$url/webapi/$pathValue');
  try {
    final response = await http.post(mUrl, body: {
      'api': apiName,
      'version': maxVersionValue.toString(),
      ...param
    });
    return {
      'req_success': true,
      'code': response.statusCode,
      'payload': jsonDecode(response.body)
    };
  } catch(err) {
    return {
      'req_success': false,
      'reason': err
    };
  }
}

/*
요약 : 매개변수로 받은 API 데이터를 기반으로 API를 호출하는 함수
매개변수 : base url, 호출할 API 이름, 호출할 API 데이터, 전달할 매개변수
 */
Future<Map> requestAPITest(String url, String apiName, Map apiParam, Map param) async {
  int maxVersionValue = apiParam['maxVersion'];
  String pathValue = apiParam['path'];
  print('API 요청 : $url/webapi/$pathValue');
  final mUrl = Uri.parse('$url/webapi/$pathValue');
  try {
    final response = await http.post(mUrl, body: {
      'api': apiName,
      'version': maxVersionValue.toString(),
      ...param
    });
    return {
      'req_success': true,
      'code': response.statusCode,
      'payload': jsonDecode(response.body)
    };
  } catch(err) {
    return {
      'req_success': false,
      'reason': err
    };
  }
}

/*
요약 : 매개변수로 받은 API 데이터를 기반으로 API를 호출하는 함수
매개변수 : base url, 호출할 API 이름, 호출할 API 데이터, 전달할 매개변수
 */
Future<Map> requestFileUploadAPI(String url, String apiName, Map param, String fileName, String filePath) async {
  Map api = getAPI(apiName);
  int maxVersionValue = api['maxVersion'];
  String pathValue = api['path'];
  print('API 요청 : $url/webapi/$pathValue');
  final mUrl = Uri.parse('$url/webapi/$pathValue');
  try {
    // final request = await http.MultipartRequest("POST", mUrl);
    // request.fields["api"] = apiName;
    // request.fields["version"] = maxVersionValue.toString();
    // param.forEach((key, value) {
    //   request.fields[key] = value;
    // });
    // request.files.add(await http.MultipartFile.fromPath(fileName, filePath));
    // final response = await http.Response.fromStream(await request.send());
    final response = await http.post(mUrl, body: {
      'api': apiName,
      'version': maxVersionValue.toString(),
      ...param
    });
    return {
      'req_success': true,
      'code': response.statusCode,
      'payload': jsonDecode(response.body)
    };
  } catch(err) {
    return {
      'req_success': false,
      'reason': err
    };
  }
}

/*
요약 : 서비스에서 요구하는 API의 사용가능여부를 판단하는 함수
매개변수 : API 맵(Nullable)
 */
bool apiUsable(Map? api) {
  const API_AUTH = "SYNO.API.Auth";
  const DOWNLOADSTATION_INFO = "SYNO.DownloadStation.Info";
  const DOWNLOADSTATION_TASK = "SYNO.DownloadStation.Task";
  const DOWNLOADSTATION_STATISTIC = "SYNO.DownloadStation.Statistic";
  if (api == null) {
    if (!apiExist(API_AUTH)) return false;
    if (!apiExist(DOWNLOADSTATION_INFO)) return false;
    if (!apiExist(DOWNLOADSTATION_TASK)) return false;
    if (!apiExist(DOWNLOADSTATION_STATISTIC)) return false;
  } else {
    if (api[API_AUTH] == null) return false;
    if (api[DOWNLOADSTATION_INFO] == null) return false;
    if (api[DOWNLOADSTATION_TASK] == null) return false;
    if (api[DOWNLOADSTATION_STATISTIC] == null) return false;
  }
  return true;
}