<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->


# Fuery Core
### Asynchronous State Management for Dart.

## Features
* Async data fetching, caching, invalidation
* Mutation with side effect

## Installation
```bash
flutter pub add fuery_core
```

## Basic Usage
### Query
```dart
int id = 2;

// QueryResult<Post, Error>
late final post = Query.use<Post, Error>(
  queryKey: ['posts', id],
  queryFn: () => repository.getPostById(id),
);

...

print(post.data.value); // Instance of 'Post'
print(post.status); // QueryStatus.success
```

### Mutation
```dart
// MutationResult<Post, Error, void Function(String), Future<Post> Function(String)>
late final createPost = Mutation.args<String, Post, Error>(
  mutationFn: (String content) => repository.createPost(content),
  onMutate: (args) => print('mutate started'),
  onSuccess: (args, data) => print('mutate succeed'),
  onError: (args, error) => print('mutate error occurred'),
);

createPost.mutate('some content');
// or
await createPost.mutateAsync('some content');

// MutationResult<Post, Error, void Function(), Future<void> Function()>
late final removeAll = Mutation.noArgs<void, Error>(
  mutationFn: () => repository.removeAll(),
  onMutate: () => print('mutate started'),
  onSuccess: (data) => print('mutate succeed'),
  onError: (error) => print('mutate error occurred'),
);

removeAll.mutate();
// or
await removeAll.mutateAsync();
```
### Fuery Client
```dart
// invalidate
Fuery.invalidateQueries(queryKey: ['posts']);

// configuration global options
Fuery.config(QueryOptions(
  gcTime: 1000 * 60 * 60,
  staleTime: 0,
  refetchInterval: 1000 * 60 * 30,
));
```


## Todo
* Infinite Query
* More complex features like query-core (from react-query)
