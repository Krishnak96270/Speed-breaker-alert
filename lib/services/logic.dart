
import 'dart:math';

double dist(a, b, c, d) {
  const R = 6371000;
  var dLat = (c - a) * pi / 180;
  var dLon = (d - b) * pi / 180;

  var x = sin(dLat / 2) * sin(dLat / 2) +
      cos(a * pi / 180) *
          cos(c * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);

  return R * 2 * atan2(sqrt(x), sqrt(1 - x));
}
