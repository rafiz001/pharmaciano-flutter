import 'package:dio/dio.dart';
import '../../data/models/login_response_model.dart';
import '../../../../core/constants/env.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  
  AuthRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        Env.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  ServerException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final message = data is Map ? data['message'] as String? : null;
        return ServerException(message ?? 'Authentication failed');
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');
      default:
        return ServerException('Network error. Please try again.');
    }
  }
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  
  @override
  String toString() => 'ServerException: $message';
}
