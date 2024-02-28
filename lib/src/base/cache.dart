import 'package:spark_core/src/base/typedefs.dart';

abstract class Cache<D> {
  D? find(SparkKey key);

  List<D> findAll({
    required SparkKey key,
    bool? exact,
  });

  bool has(SparkKey key);

  void add(SparkKey key, D value);

  void remove(SparkKey key);
}
