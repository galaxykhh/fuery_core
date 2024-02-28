part of 'spark_exception.dart';

class InvalidTimestampException extends SparkException {
  InvalidTimestampException({
    super.message,
    required this.value,
  });

  final int value;
}