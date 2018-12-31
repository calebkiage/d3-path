import 'dart:math' as Math;

double pi = Math.pi;
double tau = 2 * pi;
double epsilon = 1e-6;
double tauEpsilon = tau - epsilon;

Path path() {
  return Path();
}

class Path {
  // start of current subpath
  num _x0 = null;
  num _y0 = null;

  // end of current subpath
  num _x1 = null;
  num _y1 = null;
  String _ = "";

  void moveTo(num x, num y) {
    this._ += "M${(this._x0 = this._x1 = x)},${(this._y0 = this._y1 = y)}";
  }

  void closePath() {
    if (this._x1 != null) {
      this._x1 = this._x0;
      this._y1 = this._y0;
      this._ += "Z";
    }
  }

  void lineTo(num x, num y) {
    this._ += "L${(this._x1 = x)},${(this._y1 = y)}";
  }

  void quadraticCurveTo(num x1, num y1, num x, num y) {
    this._ += "Q$x1,$y1,${this._x1 = x},${this._y1 = y}";
  }

  void bezierCurveTo(num x1, num y1, num x2, num y2, num x, num y) {
    this._ += "C$x1,$y1,$x2,$y2,${this._x1 = x},${this._y1 = y}";
  }

  void arcTo(num x1, num y1, num x2, num y2, num r) {
    num x0 = this._x1 ?? 0;
    num y0 = this._y1 ?? 0;
    num x21 = x2 - x1;
    num y21 = y2 - y1;
    num x01 = x0 - x1;
    num y01 = y0 - y1;
    num l01_2 = x01 * x01 + y01 * y01;

    // Is the radius negative? Error.
    if (r < 0) throw new Exception("negative radius: $r");

    r = r ?? 0;

    // Is this path empty? Move to (x1,y1).
    if (this._x1 == null) {
      this._ += "M${(this._x1 = x1)},${(this._y1 = y1)}";
    }
    // Or, is (x1,y1) coincident with (x0,y0)? Do nothing.
    else if (!(l01_2 > epsilon));

    // Or, are (x0,y0), (x1,y1) and (x2,y2) collinear?
    // Equivalently, is (x1,y1) coincident with (x2,y2)?
    // Or, is the radius zero? Line to (x1,y1).
    else if (!((y01 * x21 - y21 * x01).abs() > epsilon) || r == 0) {
      this._ += "L${(this._x1 = x1)},${(this._y1 = y1)}";
    }

    // Otherwise, draw an arc!
    else {
      var x20 = x2 - x0,
          y20 = y2 - y0,
          l21_2 = x21 * x21 + y21 * y21,
          l20_2 = x20 * x20 + y20 * y20,
          l21 = Math.sqrt(l21_2),
          l01 = Math.sqrt(l01_2),
          l = r *
              Math.tan(
                  (pi - Math.acos((l21_2 + l01_2 - l20_2) / (2 * l21 * l01))) /
                      2),
          t01 = l / l01,
          t21 = l / l21;

      // If the start tangent is not coincident with (x0,y0), line to.
      if ((t01 - 1).abs() > epsilon) {
        this._ += "L${(x1 + t01 * x01)},${(y1 + t01 * y01)}";
      }

      this._ +=
          "A$r,$r,0,0,${(y01 * x20 > x01 * y20) ? 1 : 0},${(this._x1 = x1 + t21 * x21)},${(this._y1 = y1 + t21 * y21)}";
    }
  }

  void arc(num x, num y, num r, num a0, num a1, {bool ccw = false}) {
    num dx = r * Math.cos(a0);
    num dy = r * Math.sin(a0);
    num x0 = x + dx;
    num y0 = y + dy;
    num cw = 1 ^ (ccw ? 1 : 0);
    num da = ccw ? a0 - a1 : a1 - a0;

    // Is the radius negative? Error.
    if (r < 0) throw Exception("negative radius: $r");

    r = r ?? 0;

    // Is this path empty? Move to (x0,y0).
    if (this._x1 == null) {
      this._ += "M$x0,$y0";
    }

    // Or, is (x0,y0) not coincident with the previous point? Line to (x0,y0).
    else if ((this._x1 - x0).abs() > epsilon ||
        (this._y1 - y0).abs() > epsilon) {
      this._ += "L$x0,$y0";
    }

    // Is this arc empty? We’re done.
    if (r == 0) return;

    // Does the angle go the wrong way? Flip the direction.
    // Using % always returns a non-negative number. Use remainder instead.
    if (da < 0) da = da.remainder(tau) + tau;

    // Is this a complete circle? Draw two arcs to complete the circle.
    if (da > tauEpsilon) {
      this._ +=
          "A$r,$r,0,1,$cw,${(x - dx)},${(y - dy)}A$r,$r,0,1,$cw,${(this._x1 = x0)},${(this._y1 = y0)}";
    }

    // Is this arc non-empty? Draw an arc!
    else if (da > epsilon) {
      this._ +=
          "A$r,$r,0,${(da >= pi) ? 1 : 0},$cw,${(this._x1 = x + (r * Math.cos(a1)))},${(this._y1 = y + (r * Math.sin(a1)))}";
    }
  }

  void rect(num x, num y, num w, num h) {
    this._ +=
        "M${(this._x0 = this._x1 = x)},${(this._y0 = this._y1 = y)}h${w}v${h}h${-w}Z";
  }

  @override
  String toString() {
    return this._;
  }
}
