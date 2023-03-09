import 'dart:ffi';

class DownloadTask {
  String? _id;
  String? _type;
  String? _username;
  String? _title;
  String? _size;
  String? _status;
  String? _status_extra;
  DownloadTaskDetail? _detail;
  List<DownloadTaskFile>? _file;
}

class DownloadTaskDetail {
  int? _connectedLeechers;
  int? _connectedSedders;
  int? _totalPeers;
  String? _create_time;
  String? _destination;
  String? _priority;
  String? _uri;
}

class DownloadTaskFile {
  String? _filename;
  String? _priority;
  String? _size;
  String? _sizeDownloaded;
}