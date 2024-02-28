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


# Fuery
### Asynchronous State Management for Dart.

## Features
* Async data fetching, caching, invalidation
* Mutation with side effect

## Installation
```bash
flutter pub add fuery
```

## Basic Usage
### Query
```dart
int id = 2;

final post = Query.use<Post, Error>(
  queryKey: ['posts', id],
  queryFn: () => repository.getPostById(id),
);

print(post.stream.value);
print(post.status);
```

### Mutation
```dart
// with arguments
final createPost = Mutation.args<String, Post, Error>(
  mutationFn: (String content) => repository.createPost(content),
);

mutation.mutate(args: 'some content');
mutation.mutateAsync(args: 'some content');

// without arguments

final removePost = Mutation.noArgs<void, Exception>(
  mutationFn: () => repository.methodHasNoArguments(),
);

removePost.mutate();
removePost.mutateAsync();
```
### FueryClient
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
* Mutation caching system
* Improve Mutation usability (type safe arguments, ..etc)
