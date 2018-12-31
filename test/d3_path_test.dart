import 'dart:math' as Math;

import 'package:d3_path/d3_path.dart';
import 'package:test/test.dart';
import 'path_equal.dart';

void main() {
  test('path is an instance of path', () {
    var p = Path();
    expect(p is Path, isTrue);
    expect(p.toString(), equals(''));
  });

  test('path.moveTo(x, y) appends an M command', () {
    var p = Path();
    p.moveTo(150, 50);

    expect(p, pathEqual('M150,50'));
    p.lineTo(200, 100);
    expect(p, pathEqual('M150,50L200,100'));
    p.moveTo(100, 50);
    expect(p, pathEqual('M150,50L200,100M100,50'));
  });

  test('path.closePath() appends a Z command', () {
    var p = Path();
    p.moveTo(150, 50);
    expect(p, pathEqual('M150,50'));
    p.closePath();
    expect(p, pathEqual('M150,50Z'));
    p.closePath();
    expect(p, pathEqual('M150,50ZZ'));
  });

  test('path.closePath() does nothing if the path is empty', () {
    var p = Path();
    expect(p, pathEqual(''));
    p.closePath();
    expect(p, pathEqual(''));
  });

  test('path.lineTo(x, y) appends an L command', () {
    var p = Path();
    p.moveTo(150, 50);
    expect(p, pathEqual('M150,50'));
    p.lineTo(200, 100);
    expect(p, pathEqual('M150,50L200,100'));
    p.lineTo(100, 50);
    expect(p, pathEqual('M150,50L200,100L100,50'));
  });

  test('path.quadraticCurveTo(x1, y1, x, y) appends a Q command', () {
    var p = Path();
    p.moveTo(150, 50);
    expect(p, pathEqual('M150,50'));
    p.quadraticCurveTo(100, 50, 200, 100);
    expect(p, pathEqual('M150,50Q100,50,200,100'));
  });

  test('path.bezierCurveTo(x1, y1, x, y) appends a C command', () {
    var p = Path();
    p.moveTo(150, 50);
    expect(p, pathEqual('M150,50'));
    p.bezierCurveTo(100, 50, 0, 24, 200, 100);
    expect(p, pathEqual('M150,50C100,50,0,24,200,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) throws an error if the radius is negative',
      () {
    var p = Path();
    p.moveTo(150, 100);
    var fun = () {
      p.arc(100, 100, -50, 0, Math.pi / 2);
    };
    expect(fun, throwsException);
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append only an M command if the radius is zero',
      () {
    var p = Path();
    p.arc(100, 100, 0, 0, Math.pi / 2);
    expect(p, pathEqual('M100,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append only an L command if the radius is zero',
      () {
    var p = Path();
    p.moveTo(0, 0);
    p.arc(100, 100, 0, 0, Math.pi / 2);
    expect(p, pathEqual('M0,0L100,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append only an M command if the angle is zero',
      () {
    var p = Path();
    p.arc(100, 100, 0, 0, 0);
    expect(p, pathEqual('M100,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append only an M command if the angle is near zero',
      () {
    var p = Path();
    p.arc(100, 100, 0, 0, 1e-16);
    expect(p, pathEqual('M100,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append an M command if the path was empty',
      () {
    var p = Path();
    p.arc(100, 100, 50, 0, Math.pi * 2);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
    p = Path();
    p.arc(0, 50, 50, -Math.pi / 2, 0);
    expect(p, pathEqual('M0,0A50,50,0,0,1,50,50'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) may append an L command if the arc doesn’t start at the current point',
      () {
    var p = Path();
    p.moveTo(100, 100);
    p.arc(100, 100, 50, 0, Math.pi * 2);
    expect(p,
        pathEqual('M100,100L150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) appends a single A command if the angle is less than π',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, Math.pi / 2);
    expect(p, pathEqual('M150,100A50,50,0,0,1,100,150'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) appends a single A command if the angle is less than τ',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, Math.pi * 1);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100'));
  });

  test(
      'path.arc(x, y, radius, startAngle, endAngle) appends two A commands if the angle is greater than τ',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, Math.pi * 2);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, π/2, false) draws a small clockwise arc', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, Math.pi / 2, false);
    expect(p, pathEqual('M150,100A50,50,0,0,1,100,150'));
  });

  test('path.arc(x, y, radius, -π/2, 0, false) draws a small clockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, -Math.pi / 2, 0, false);
    expect(p, pathEqual('M100,50A50,50,0,0,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, ε, true) draws an anticlockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 1e-16, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,50,100A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, 0, ε, false) draws nothing', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 1e-16, false);
    expect(p, pathEqual('M150,100'));
  });

  test('path.arc(x, y, radius, 0, -ε, true) draws nothing', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, -1e-16, true);
    expect(p, pathEqual('M150,100'));
  });

  test('path.arc(x, y, radius, 0, -ε, false) draws a clockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, -1e-16, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, τ, true) draws an anticlockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,50,100A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, 0, τ, false) draws a clockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, τ + ε, true) draws an anticlockwise circle',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi + 1e-13, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,50,100A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, 0, τ - ε, false) draws a clockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi - 1e-13, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, τ, 0, true) draws an anticlockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,50,100A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, τ, 0, false) draws a clockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 2 * Math.pi, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, 13π/2, false) draws a clockwise circle', () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 13 * Math.pi / 2, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,50,100A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 13π/2, 0, false) draws a big clockwise arc', () {
    var p = Path();
    p.moveTo(100, 150);
    p.arc(100, 100, 50, 13 * Math.pi / 2, 0, false);
    expect(p, pathEqual('M100,150A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, π/2, 0, false) draws a big clockwise arc', () {
    var p = Path();
    p.moveTo(100, 150);
    p.arc(100, 100, 50, Math.pi / 2, 0, false);
    expect(p, pathEqual('M100,150A50,50,0,1,1,150,100'));
  });

  test('path.arc(x, y, radius, 3π/2, 0, false) draws a small clockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, 3 * Math.pi / 2, 0, false);
    expect(p, pathEqual('M100,50A50,50,0,0,1,150,100'));
  });

  test('path.arc(x, y, radius, 15π/2, 0, false) draws a small clockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, 15 * Math.pi / 2, 0, false);
    expect(p, pathEqual('M100,50A50,50,0,0,1,150,100'));
  });

  test('path.arc(x, y, radius, 0, π/2, true) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, Math.pi / 2, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,100,150'));
  });

  test('path.arc(x, y, radius, -π/2, 0, true) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, -Math.pi / 2, 0, true);
    expect(p, pathEqual('M100,50A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, -13π/2, 0, true) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, -13 * Math.pi / 2, 0, true);
    expect(p, pathEqual('M100,50A50,50,0,1,0,150,100'));
  });

  test('path.arc(x, y, radius, -13π/2, 0, false) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, -13 * Math.pi / 2, false);
    expect(p, pathEqual('M150,100A50,50,0,1,1,100,50'));
  });

  test('path.arc(x, y, radius, 0, 13π/2, true) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(150, 100);
    p.arc(100, 100, 50, 0, 13 * Math.pi / 2, true);
    expect(p, pathEqual('M150,100A50,50,0,1,0,100,150'));
  });

  test('path.arc(x, y, radius, π/2, 0, true) draws a small anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 150);
    p.arc(100, 100, 50, Math.pi / 2, 0, true);
    expect(p, pathEqual('M100,150A50,50,0,0,0,150,100'));
  });

  test('path.arc(x, y, radius, 3π/2, 0, true) draws a big anticlockwise arc',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arc(100, 100, 50, 3 * Math.pi / 2, 0, true);
    expect(p, pathEqual('M100,50A50,50,0,1,0,150,100'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) throws an error if the radius is negative',
      () {
    var p = Path();
    p.moveTo(150, 100);
    expect(() {
      p.arcTo(270, 39, 163, 100, -53);
    }, throwsException);
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends an M command if the path was empty',
      () {
    var p = Path();
    p.arcTo(270, 39, 163, 100, 53);
    expect(p, pathEqual('M270,39'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) does nothing if the previous point was ⟨x1,y1⟩',
      () {
    var p = Path();
    p.moveTo(270, 39);
    p.arcTo(270, 39, 163, 100, 53);
    expect(p, pathEqual('M270,39'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends an L command if the previous point, ⟨x1,y1⟩ and ⟨x2,y2⟩ are collinear',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arcTo(101, 51, 102, 52, 10);
    expect(p, pathEqual('M100,50L101,51'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends an L command if ⟨x1,y1⟩ and ⟨x2,y2⟩ are coincident',
      () {
    var p = Path();
    p.moveTo(100, 50);
    p.arcTo(101, 51, 101, 51, 10);
    expect(p, pathEqual('M100,50L101,51'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends an L command if the radius is zero',
      () {
    var p = Path();
    p.moveTo(270, 182);
    p.arcTo(270, 39, 163, 100, 0);
    expect(p, pathEqual('M270,182L270,39'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends L and A commands if the arc does not start at the current point',
      () {
    var p = Path();
    p.moveTo(270, 182);
    p.arcTo(270, 39, 163, 100, 53);
    expect(p,
        pathEqual('M270,182L270,130.222686A53,53,0,0,0,190.750991,84.179342'));
    p = Path();
    p.moveTo(270, 182);
    p.arcTo(270, 39, 363, 100, 53);
    expect(p,
        pathEqual('M270,182L270,137.147168A53,53,0,0,1,352.068382,92.829799'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) appends only an A command if the arc starts at the current point',
      () {
    var p = Path();
    p.moveTo(100, 100);
    p.arcTo(200, 100, 200, 200, 100);
    expect(p, pathEqual('M100,100A100,100,0,0,1,200,200'));
  });

  test(
      'path.arcTo(x1, y1, x2, y2, radius) sets the last point to be the end tangent of the arc',
      () {
    var p = Path();
    p.moveTo(100, 100);
    p.arcTo(200, 100, 200, 200, 50);
    p.arc(150, 150, 50, 0, Math.pi);
    expect(p,
        pathEqual('M100,100L150,100A50,50,0,0,1,200,150A50,50,0,1,1,100,150'));
  });

  test('path.rect(x, y, w, h) appends M, h, v, h, and Z commands', () {
    var p = Path();
    p.moveTo(150, 100);
    p.rect(100, 200, 50, 25);
    expect(p, pathEqual('M150,100M100,200h50v25h-50Z'));
  });
}
