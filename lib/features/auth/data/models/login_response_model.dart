import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final LoginDataModel? data;
  
  const LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null 
          ? LoginDataModel.fromJson(json['data'] as Map<String, dynamic>) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class LoginDataModel {
  final String token;
  final UserModel user;
  
  const LoginDataModel({
    required this.token,
    required this.user,
  });
  
  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
