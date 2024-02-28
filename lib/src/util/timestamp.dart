// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:spark_core/src/error/spark_exception.dart';

class Timestamp {
  const Timestamp(this.value);

  final int value;

  factory Timestamp.fromDateTime(DateTime dateTime) {
    return Timestamp(dateTime.millisecondsSinceEpoch);
  }

  factory Timestamp.now() {
    return Timestamp.fromDateTime(DateTime.now());
  }

  DateTime toDateTime() {
    try {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } catch (_) {
      throw InvalidTimestampException(
        value: value,
        message: 'invalid timestamp value: $value',
      );
    }
  }

  Timestamp difference(Timestamp other) {
    final Duration diff = toDateTime().difference(other.toDateTime());

    return Timestamp(diff.inMilliseconds);
  }

  @override
  bool operator ==(covariant Timestamp other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
