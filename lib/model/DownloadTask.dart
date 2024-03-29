class DownloadTask {
  String _id;
  String _size;
  String _status;
  String _status_extra;
  String _title;
  String _type;
  String _username;

  DownloadTaskDetail? _detail;
  List<DownloadTaskFile> _files = [];

  DownloadTask(this._id, this._size, this._status, this._status_extra, this._title, this._type, this._username);

  getId(){return _id;}
  getType(){return _type;}
  getUsername(){return _username;}
  getTitle(){return _title;}
  getSize(){return _size;}
  getStatus(){return _status;}
  getStatusExtra(){return _status_extra;}
  getAddiDetail(){return _detail;}
  getAddiFiles(){return _files;}

  addAddiFile(DownloadTaskFile file){_files.add(file);}
  setAddiDetail(DownloadTaskDetail detail){_detail = detail;}
}

class DownloadTaskDetail {
  int _connectedLeechers;
  int _connectedSeeders;
  int _totalPeers;
  String _createTime;
  String _destination;
  String _priority;
  String _uri;

  DownloadTaskDetail(this._connectedLeechers, this._connectedSeeders, this._totalPeers, this._createTime, this._destination, this._priority, this._uri);

  getConnLeechers(){return _connectedLeechers;}
  getConnSeeders(){return _connectedSeeders;}
  getTotalPeers(){return _totalPeers;}
  getCreateTime(){return _createTime;}
  getDestination(){return _destination;}
  getPriority(){return _priority;}
  getUri(){return _uri;}
}

class DownloadTaskFile {
  String _filename;
  String _priority;
  String _size;
  String _sizeDownloaded;

  DownloadTaskFile(this._filename, this._priority, this._size, this._sizeDownloaded);

  getFilename(){return _filename;}
  getPriority(){return _priority;}
  getSize(){return _size;}
  getSizeDownloaded(){return _sizeDownloaded;}
}