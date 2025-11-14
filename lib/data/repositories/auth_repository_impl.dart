import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase/auth_datasource.dart';

/// Auth Repository Implementation with Either<Failure, T> pattern
/// Implements the domain auth repository interface
/// Uses Firebase as the data source with proper error conversion
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  const AuthRepositoryImpl({
    required FirebaseAuthDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      final userModel = await _dataSource.signUp(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.login(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dataSource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> sendPasswordResetEmail(String email) async {
    try {
      final result = await _dataSource.sendPasswordResetEmail(email);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to send password reset email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail() async {
    try {
      await _dataSource.verifyEmail();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to verify email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, User?>> authStateChanges() {
    try {
      return _dataSource.authStateChanges().map((userModel) {
        return Right<Failure, User?>(userModel?.toEntity());
      }).handleError((error) {
        if (error is AuthException) {
          return Left<Failure, User?>(AuthFailure(error.message, code: error.code));
        } else if (error is NetworkException) {
          return Left<Failure, User?>(NetworkFailure(error.message, code: error.code));
        } else {
          return Left<Failure, User?>(ServerFailure('Auth state error: ${error.toString()}'));
        }
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure('Failed to listen to auth state: ${e.toString()}')));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final result = await _dataSource.isAuthenticated();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to check authentication status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    try {
      // TODO: Implement email update functionality in datasource
      throw const AuthException('Email update not implemented yet', code: 'NOT_IMPLEMENTED');
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to update email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // TODO: Implement password update functionality in datasource
      throw const AuthException('Password update not implemented yet', code: 'NOT_IMPLEMENTED');
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to update password: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      // TODO: Implement account deletion functionality in datasource
      throw const AuthException('Account deletion not implemented yet', code: 'NOT_IMPLEMENTED');
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to delete account: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> reauthenticate(String password) async {
    try {
      // TODO: Implement re-authentication functionality in datasource
      throw const AuthException('Re-authentication not implemented yet', code: 'NOT_IMPLEMENTED');
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Failed to re-authenticate: ${e.toString()}'));
    }
  }
}