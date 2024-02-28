import 'package:spark_core/base/typedefs.dart';

part 'mutation_state.dart';
part '../mutation.dart';
part '../mutation_with_args.dart';
part '../mutation_without_args.dart';
part '../mutation_state.dart';

abstract class MutationBase<Args, Data> {
  MutationBase({
    required MutationKey mutationKey,
  }) : _mutationKey = mutationKey;

  final MutationKey _mutationKey;
  MutationKey get mutationKey => _mutationKey;

  void mutate([Args args]);

  Future<Data> mutateAsync([Args args]);
}
