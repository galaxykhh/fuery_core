import 'dart:async';

typedef SparkKey = List<dynamic>;

typedef QueryKey = SparkKey;

typedef QueryFn<T> = Future<T> Function();

typedef MutationKey = SparkKey;

typedef MutationAsyncFn<Args, Data, Err> = Future<Data> Function(Args args);

typedef MutationSyncFn<Args, Data, Err> = void Function(Args args);

typedef MutationNoArgsAsyncFn<Data, Err> = Future<Data> Function();

typedef MutationNoArgsSyncFn<Data, Err> = void Function();

typedef Store<T> = Map<String, T>;

typedef MutationMutateCallback<Args> = void Function(Args args);

typedef MutationMutateCallbackWithoutArgs = void Function();

typedef MutationSuccessCallback<Args, Data> = void Function(Args args, Data data);

typedef MutationSuccessCallbackWithoutArgs<Data> = void Function(Data data);

typedef MutationErrorCallback<Args, Err> = void Function(Args args, Err error);

typedef MutationErrorCallbackWithoutArgs<Err> = void Function(Err error);

typedef ValueGetter<T> = T? Function();
