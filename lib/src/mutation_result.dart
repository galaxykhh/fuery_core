import 'package:fuery_core/src/base/mutation_result.dart';
import 'package:fuery_core/src/mutation_state.dart';

class MutationResult<Data, Err> extends MutationResultBase<Data, Err, MutationState<Data, Err>> {
  MutationResult({
    required super.data,
    required super.mutate,
    required super.mutateAsync,
  });
}
