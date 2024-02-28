part of 'spark_exception.dart';

class QueryStateTypeException<T> extends SparkException {
  QueryStateTypeException({
    super.message,
    required this.data,
  });

  final T data;
}