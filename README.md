# d3-path

Say you have some code that draws to a 2D canvas:

```dart
drawCircle(context, radius) {
  context.moveTo(radius, 0);
  context.arc(0, 0, radius, 0, 2 * Math.PI);
}
```

The d3-path module lets you take this exact code and additionally render to [SVG](http://www.w3.org/TR/SVG/paths.html). It works by [serializing](#path_toString) [CanvasPathMethods](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls to [SVG path data](http://www.w3.org/TR/SVG/paths.html#PathData). For example:

```dart
var context = path();
drawCircle(context, 40);
print(context.toString());
```

Now code you write once can be used with both Canvas (for performance) and SVG (for convenience). For a practical example, see [d3-shape](https://github.com/calebkiage/d3-shape).

## Installing

Add the following dependency to your yaml file.

```yaml
dependencies
  d3_path:
    git:
      url: git://github.com/calebkiage/d3-path.git
```


```dart
import 'package:d3_path/d3_path.dart';

var path = path();
path.moveTo(1, 2);
path.lineTo(3, 4);
path.closePath();

```

[Try d3-path in your browser.](https://tonicdev.com/npm/d3-path)

## API Reference

<a name="path" href="#path">#</a> d3.<b>path</b>() [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart "Source")

Constructs a new path serializer that implements [CanvasPathMethods](http://www.w3.org/TR/2dcontext/#canvaspathmethods).

<a name="path_moveTo" href="#path_moveTo">#</a> <i>path</i>.<b>moveTo</b>(<i>x</i>, <i>y</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L18 "Source")

Move to the specified point ⟨*x*, *y*⟩. Equivalent to [*context*.moveTo](http://www.w3.org/TR/2dcontext/#dom-context-2d-moveto) and SVG’s [“moveto” command](http://www.w3.org/TR/SVG/paths.html#PathDataMovetoCommands).

<a name="path_closePath" href="#path_closePath">#</A> <i>path</i>.<b>closePath</b>() [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L21 "Source")

Ends the current subpath and causes an automatic straight line to be drawn from the current point to the initial point of the current subpath. Equivalent to [*context*.closePath](http://www.w3.org/TR/2dcontext/#dom-context-2d-closepath) and SVG’s [“closepath” command](http://www.w3.org/TR/SVG/paths.html#PathDataClosePathCommand).

<a name="path_lineTo" href="#path_lineTo">#</a> <i>path</i>.<b>lineTo</b>(<i>x</i>, <i>y</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L27 "Source")

Draws a straight line from the current point to the specified point ⟨*x*, *y*⟩. Equivalent to [*context*.lineTo](http://www.w3.org/TR/2dcontext/#dom-context-2d-lineto) and SVG’s [“lineto” command](http://www.w3.org/TR/SVG/paths.html#PathDataLinetoCommands).

<a name="path_quadraticCurveTo" href="#path_quadraticCurveTo">#</a> <i>path</i>.<b>quadraticCurveTo</b>(<i>cpx</i>, <i>cpy</i>, <i>x</i>, <i>y</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L30 "Source")

Draws a quadratic Bézier segment from the current point to the specified point ⟨*x*, *y*⟩, with the specified control point ⟨*cpx*, *cpy*⟩. Equivalent to [*context*.quadraticCurveTo](http://www.w3.org/TR/2dcontext/#dom-context-2d-quadraticcurveto) and SVG’s [quadratic Bézier curve commands](http://www.w3.org/TR/SVG/paths.html#PathDataQuadraticBezierCommands).

<a name="path_bezierCurveTo" href="#path_bezierCurveTo">#</a> <i>path</i>.<b>bezierCurveTo</b>(<i>cpx1</i>, <i>cpy1</i>, <i>cpx2</i>, <i>cpy2</i>, <i>x</i>, <i>y</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L33 "Source")

Draws a cubic Bézier segment from the current point to the specified point ⟨*x*, *y*⟩, with the specified control points ⟨*cpx1*, *cpy1*⟩ and ⟨*cpx2*, *cpy2*⟩. Equivalent to [*context*.bezierCurveTo](http://www.w3.org/TR/2dcontext/#dom-context-2d-beziercurveto) and SVG’s [cubic Bézier curve commands](http://www.w3.org/TR/SVG/paths.html#PathDataCubicBezierCommands).

<a name="path_arcTo" href="#path_arcTo">#</a> <i>path</i>.<b>arcTo</b>(<i>x1</i>, <i>y1</i>, <i>x2</i>, <i>y2</i>, <i>radius</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L36 "Source")

Draws a circular arc segment with the specified *radius* that starts tangent to the line between the current point and the specified point ⟨*x1*, *y1*⟩ and ends tangent to the line between the specified points ⟨*x1*, *y1*⟩ and ⟨*x2*, *y2*⟩. If the first tangent point is not equal to the current point, a straight line is drawn between the current point and the first tangent point. Equivalent to [*context*.arcTo](http://www.w3.org/TR/2dcontext/#dom-context-2d-arcto) and uses SVG’s [elliptical arc curve commands](http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands).

<a name="path_arc" href="#path_arc">#</a> <i>path</i>.<b>arc</b>(<i>x</i>, <i>y</i>, <i>radius</i>, <i>startAngle</i>, <i>endAngle</i>[, <i>anticlockwise</i>]) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L84 "Source")

Draws a circular arc segment with the specified center ⟨*x*, *y*⟩, *radius*, *startAngle* and *endAngle*. If *anticlockwise* is true, the arc is drawn in the anticlockwise direction; otherwise, it is drawn in the clockwise direction. If the current point is not equal to the starting point of the arc, a straight line is drawn from the current point to the start of the arc. Equivalent to [*context*.arc](http://www.w3.org/TR/2dcontext/#dom-context-2d-arc) and uses SVG’s [elliptical arc curve commands](http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands).

<a name="path_rect" href="#path_rect">#</a> <i>path</i>.<b>rect</b>(<i>x</i>, <i>y</i>, <i>w</i>, <i>h</i>) [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L122 "Source")

Creates a new subpath containing just the four points ⟨*x*, *y*⟩, ⟨*x* + *w*, *y*⟩, ⟨*x* + *w*, *y* + *h*⟩, ⟨*x*, *y* + *h*⟩, with those four points connected by straight lines, and then marks the subpath as closed. Equivalent to [*context*.rect](http://www.w3.org/TR/2dcontext/#dom-context-2d-rect) and uses SVG’s [“lineto” commands](http://www.w3.org/TR/SVG/paths.html#PathDataLinetoCommands).

<a name="path_toString" href="#path_toString">#</a> <i>path</i>.<b>toString</b>() [<>](https://github.com/calebkiage/d3-path/blob/master/lib/src/path.dart#L125 "Source")

Returns the string representation of this *path* according to SVG’s [path data specification](http://www.w3.org/TR/SVG/paths.html#PathData).

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/calebkiage/d3-path/issues
