import 'package:get_it/get_it.dart';

import 'base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'my_account/data/repository/user_profile_repository_impl.dart';
import 'my_account/domain/repository/user_profile_repository.dart';
import 'my_account/domain/use_case/change_password_use_case.dart';
import 'my_account/domain/use_case/get_user_profile_use_case.dart';
import 'my_account/domain/use_case/logout_use_case.dart';
import 'my_account/domain/use_case/update_user_profile_use_case.dart';
import 'my_account/presentation/bloc/my_account_bloc.dart';

void initializeDi(GetIt getIt) {
  // ─── Existing examples ─────────────────────────────────────────────────────
  getIt.registerFactory<BaseBlocExampleScreenBloc>(
    BaseBlocExampleScreenBloc.new,
  );
  getIt.registerFactory<BaseCubitExampleScreenCubit>(
    BaseCubitExampleScreenCubit.new,
  );

  // ─── My Account ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<UserProfileRepository>(
    UserProfileRepositoryImpl.new,
  );

  getIt.registerLazySingleton(
    () => GetUserProfileUseCase(getIt<UserProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateUserProfileUseCase(getIt<UserProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(getIt<UserProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => LogoutUseCase(getIt<UserProfileRepository>()),
  );

  getIt.registerFactory<MyAccountBloc>(
    () => MyAccountBloc(
      getProfile: getIt<GetUserProfileUseCase>(),
      updateProfile: getIt<UpdateUserProfileUseCase>(),
      changePassword: getIt<ChangePasswordUseCase>(),
      logout: getIt<LogoutUseCase>(),
    ),
  );
}
