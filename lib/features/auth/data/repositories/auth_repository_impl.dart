import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/utils/hive_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      // Persist token and user to Hive
      await HiveHelper.saveToken(response.data!.token);
      await HiveHelper.saveUser(response.data!.user.toJson());
      
      return Result.success(response.data!.user.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }
  
  @override
  void logout() {
    HiveHelper.clearAuth();
  }
  
  @override
  bool get isAuthenticated => HiveHelper.isAuthenticated;
}
