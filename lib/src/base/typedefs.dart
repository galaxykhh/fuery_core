import 'dart:async';

typedef SparkKey = List<dynamic>;

typedef QueryKey = SparkKey;

typedef QueryFn<T> = Future<T> Function();

typedef MutationKey = SparkKey;

typedef MutationWithArgsFn<Args, Data, Err> = Future<Data> Function(Args args);

typedef MutationWithoutArgsFn<Data, Err> = Future<Data> Function();

typedef Store<T> = Map<String, T>;

typedef MutationMutateCallback<Args> = void Function(Args args);

typedef MutationMutateCallbackWithoutArgs = void Function();

typedef MutationSuccessCallback<Args, Data> = void Function(Data data, Args args);

typedef MutationSuccessCallbackWithoutArgs<Data> = void Function(Data data);

typedef MutationErrorCallback<Args, Err> = void Function(Err error, Args args);

typedef MutationErrorCallbackWithoutArgs<Err> = void Function(Err error);

typedef ValueGetter<T> = T? Function();
