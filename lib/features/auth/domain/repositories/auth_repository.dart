import '../entities/user_entity.dart';

// Simple Either-like result without external package
class Result<T> {
  final T? _value;
  final String? _error;
  
  const Result._(this._value, this._error);
  
  factory Result.success(T value) => Result._(value, null);
  factory Result.failure(String error) => Result._(null, error);
  
  bool get isSuccess => _error == null;
  bool get isFailure => _error != null;
  
  T? get value => _value;
  String? get error => _error;
  
  // Functional style handling
  R fold<R>(R Function(String error) onError, R Function(T value) onSuccess) {
    if (isFailure) {
      return onError(_error!);
    }
    final val = _value;
    if (val == null) {
      throw StateError('Success result should have a value');
    }
    return onSuccess(val);
  }
}

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });
  
  void logout();
  bool get isAuthenticated;
}
