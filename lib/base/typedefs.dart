typedef SparkKey = List<dynamic>;

typedef QueryKey = SparkKey;

typedef QueryFn<T> = Future<T> Function();

typedef MutationKey = SparkKey;

typedef MutationWithArgsFn<Args, Data, Err> = Future<Data> Function(Args args);

typedef MutationWithoutArgsFn<Data, Err> = Future<Data> Function();

typedef Store<T> = Map<String, T>;