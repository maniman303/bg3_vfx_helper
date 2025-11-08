import 'dart:math' as math;

extension Splits<T> on List<T> {
  List<List<T>> split(int batchSize) {
    batchSize = math.max(1, batchSize);
    var start = 0;

    final result = List<List<T>>.empty(growable: true);

    while (start < length) {
      var end = math.min(start + batchSize, length);

      var sublist = this.sublist(start, end);
      result.add(sublist);
      start += batchSize;
    }

    return result;
  }

  List<T> sublistLength(int length) {
    length = math.max(0, math.min(length, this.length));

    return sublist(0, length);
  }
}
