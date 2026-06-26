import 'package:flutter_clean_architecture_starter/core/result/result.dart';

abstract class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

class NoParams {
  const NoParams();
}
