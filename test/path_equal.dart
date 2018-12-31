import 'package:matcher/matcher.dart';
import 'package:d3_path/d3_path.dart';

var reNumber = RegExp(r'[-+]?(?:\d+\.\d+|\d+\.|\.\d+|\d+)(?:[eE][-]?\d+)?');

Matcher pathEqual(String expected) => _PathMatcher(expected);

class _PathMatcher extends Matcher {
  final String _value;

  _PathMatcher(this._value);

  @override
  Description describe(Description description) {
    return null;
  }

  @override
  bool matches(item, Map matchState) {
    var pathString;
    if (item is Path) {
      pathString = item.toString();
    } else if (item is String) {
      pathString = item;
    } else {
      pathString = null;
    }

    var actual = _normalizePath(this._value + "");
    var expected = _normalizePath(pathString + "");

    return actual == expected;
  }

  _normalizePath(String path) {
    return path.replaceAllMapped(reNumber, (m) {
      var match = m[0];
      var n = num.tryParse(match);
      return _formatNumber(n);
    });
  }

  String _formatNumber(num s) {
    return '${(s - s.round()).abs() < 1e-6 ? s.round() : s.toStringAsFixed(6)}';
  }
}