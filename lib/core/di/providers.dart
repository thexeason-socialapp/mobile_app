import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';

// Data layer
import '../../data/datasources/remote/firebase/auth_datasource.dart';
import '../../data/datasources/remote/firebase/firebase_service.dart';
import '../../data/datasources/remote/rest_api/users_api.dart';
import '../../data/datasources/local/boxes/user_box.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';

// Domain layer
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/auth/check_username_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/reset_password_usecase.dart';
import '../../domain/usecases/auth/verify_email_usecase.dart';

// ===== FIREBASE PROVIDERS =====

final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return FirebaseService.instance.auth;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseService.instance.firestore;
});

// ===== DATA SOURCE PROVIDERS =====

final authDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firestoreProvider);
  
  return FirebaseAuthDataSource(
    auth: firebaseAuth,
    firestore: firestore,
  );
});

// ===== REPOSITORY PROVIDERS =====

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.read(authDataSourceProvider);
  
  return AuthRepositoryImpl(
    dataSource: authDataSource,
  );
});

// ===== USE CASE PROVIDERS =====

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUseCase(authRepository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignUpUseCase(authRepository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUseCase(authRepository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ResetPasswordUseCase(authRepository);
});

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return VerifyEmailUseCase(authRepository);
});

final checkUsernameUseCaseProvider = Provider<CheckUsernameUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return CheckUsernameUseCase(authRepository);
});

// ===== PROFILE PROVIDERS =====

// Storage provider
final firebaseStorageProvider = Provider((ref) {
  return FirebaseService.instance.storage;
});

// Logger provider
final loggerProvider = Provider((ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
});

// Users API provider
final usersApiProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  final storage = ref.read(firebaseStorageProvider);
  final logger = ref.read(loggerProvider);

  return UsersApi(
    firestore: firestore,
    storage: storage,
    logger: logger,
  );
});

// User Box provider
final userBoxProvider = Provider((ref) {
  return UserBox();
});

// User Repository provider (override the one in profile_state_provider)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final usersApi = ref.read(usersApiProvider);
  final userBox = ref.read(userBoxProvider);
  final logger = ref.read(loggerProvider);

  return UserRepositoryImpl(
    usersApi: usersApi,
    userBox: userBox,
    logger: logger,
  );
});