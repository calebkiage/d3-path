import 'package:d3_path/d3_path.dart';

main() {
  var _path = path();
  _path.arc(200, 200, 200, 10, 200);
  print('Path: ${_path}');
}
