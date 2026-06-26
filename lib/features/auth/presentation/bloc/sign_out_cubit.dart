import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_out.dart';

class SignOutCubit extends Cubit<void> {
  SignOutCubit({required SignOut signOut}) : _signOut = signOut, super(null);

  final SignOut _signOut;

  Future<void> signOut() async {
    await _signOut(const NoParams());
  }
}
