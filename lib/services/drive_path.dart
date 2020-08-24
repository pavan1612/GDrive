class DrivePath {
  List<String> _path;
  DrivePath() {
    _path = ['root'];
  }

  String getCuurentPath() {
    var fullPath = '';
    for (var item in _path) {
      fullPath = fullPath + '\\' + item;
    }
    return fullPath;
  }

  void pushPath(dir) {
    _path.add(dir);
  }

  void popPath() {
    if (_path.length == 1) {
      return;
    }
    _path.removeLast();
  }

  void resetPath() {
    _path = ['root'];
  }
}
