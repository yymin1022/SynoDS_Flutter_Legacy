class TaskRaw {
  Data? data;
  CustomError? error;
  bool? success;

  TaskRaw({this.data, this.error, this.success});

  TaskRaw.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'] != null ? new CustomError.fromJson(json['error']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class CustomError {
  int? code;
  CustomError({this.code});
  CustomError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Data {
  int? offset;
  List<Tasks>? tasks;
  int? total;

  Data({this.offset, this.tasks, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Tasks {
  Additional? additional;
  String? id;
  int? size;
  String? status;
  String? title;
  String? type;
  String? username;

  Tasks(
      {this.additional,
        this.id,
        this.size,
        this.status,
        this.title,
        this.type,
        this.username});

  Tasks.fromJson(Map<String, dynamic> json) {
    additional = json['additional'] != null
        ? new Additional.fromJson(json['additional'])
        : null;
    id = json['id'];
    size = json['size'];
    status = json['status'];
    title = json['title'];
    type = json['type'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.additional != null) {
      data['additional'] = this.additional!.toJson();
    }
    data['id'] = this.id;
    data['size'] = this.size;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    data['username'] = this.username;
    return data;
  }
}

class Additional {
  Detail? detail;
  Transfer? transfer;

  Additional({this.detail, this.transfer});

  Additional.fromJson(Map<String, dynamic> json) {
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    transfer = json['transfer'] != null
        ? new Transfer.fromJson(json['transfer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    if (this.transfer != null) {
      data['transfer'] = this.transfer!.toJson();
    }
    return data;
  }
}

class Detail {
  int? completedTime;
  int? connectedLeechers;
  int? connectedPeers;
  int? connectedSeeders;
  int? createTime;
  String? destination;
  int? seedelapsed;
  int? startedTime;
  int? totalPeers;
  int? totalPieces;
  String? unzipPassword;
  String? uri;
  int? waitingSeconds;

  Detail(
      {this.completedTime,
        this.connectedLeechers,
        this.connectedPeers,
        this.connectedSeeders,
        this.createTime,
        this.destination,
        this.seedelapsed,
        this.startedTime,
        this.totalPeers,
        this.totalPieces,
        this.unzipPassword,
        this.uri,
        this.waitingSeconds});

  Detail.fromJson(Map<String, dynamic> json) {
    completedTime = json['completed_time'];
    connectedLeechers = json['connected_leechers'];
    connectedPeers = json['connected_peers'];
    connectedSeeders = json['connected_seeders'];
    createTime = json['create_time'];
    destination = json['destination'];
    seedelapsed = json['seedelapsed'];
    startedTime = json['started_time'];
    totalPeers = json['total_peers'];
    totalPieces = json['total_pieces'];
    unzipPassword = json['unzip_password'];
    uri = json['uri'];
    waitingSeconds = json['waiting_seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed_time'] = this.completedTime;
    data['connected_leechers'] = this.connectedLeechers;
    data['connected_peers'] = this.connectedPeers;
    data['connected_seeders'] = this.connectedSeeders;
    data['create_time'] = this.createTime;
    data['destination'] = this.destination;
    data['seedelapsed'] = this.seedelapsed;
    data['started_time'] = this.startedTime;
    data['total_peers'] = this.totalPeers;
    data['total_pieces'] = this.totalPieces;
    data['unzip_password'] = this.unzipPassword;
    data['uri'] = this.uri;
    data['waiting_seconds'] = this.waitingSeconds;
    return data;
  }
}

class Transfer {
  int? downloadedPieces;
  int? sizeDownloaded;
  int? sizeUploaded;
  int? speedDownload;
  int? speedUpload;

  Transfer(
      {this.downloadedPieces,
        this.sizeDownloaded,
        this.sizeUploaded,
        this.speedDownload,
        this.speedUpload});

  Transfer.fromJson(Map<String, dynamic> json) {
    downloadedPieces = json['downloaded_pieces'];
    sizeDownloaded = json['size_downloaded'];
    sizeUploaded = json['size_uploaded'];
    speedDownload = json['speed_download'];
    speedUpload = json['speed_upload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['downloaded_pieces'] = this.downloadedPieces;
    data['size_downloaded'] = this.sizeDownloaded;
    data['size_uploaded'] = this.sizeUploaded;
    data['speed_download'] = this.speedDownload;
    data['speed_upload'] = this.speedUpload;
    return data;
  }
}