import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthViewModel {
  final AuthRepository _repository;
  
  AuthState _state = AuthState.initial();
  AuthState get state => _state;
  
  // Callback for state changes
  VoidCallback? listener;
  
  AuthViewModel(this._repository);
  
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading();
    listener?.call();
    
    final result = await _repository.login(
      email: email,
      password: password,
    );
    
    if (result.isSuccess) {
      _state = AuthState.success(result.value!);
    } else {
      _state = AuthState.error(result.error ?? 'Login failed');
    }
    listener?.call();
  }
  
  void logout() {
    _repository.logout();
    _state = AuthState.initial();
    listener?.call();
  }
  
  bool get isAuthenticated => _repository.isAuthenticated;
}

typedef VoidCallback = void Function();

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;
  
  AuthState._({
    required this.isLoading,
    this.user,
    this.error,
  });
  
  factory AuthState.initial() => AuthState._(isLoading: false);
  factory AuthState.loading() => AuthState._(isLoading: true);
  factory AuthState.success(UserEntity user) => AuthState._(isLoading: false, user: user);
  factory AuthState.error(String message) => AuthState._(isLoading: false, error: message);
}
