import 'package:flutter_clean_architecture_starter/core/result/result.dart';

abstract class UseCase<Output, Params> {
  const UseCase();

  Future<Result<Output>> call(Params params);
}

class NoParams {
  const NoParams();
}
