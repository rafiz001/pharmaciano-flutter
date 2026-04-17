import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

void checkIsAlreadyLoggedIn(BuildContext cntx) async {
  try {
    final isTokenExpired = await FlutterSessionJwt.isTokenExpired();
    print(isTokenExpired);
    if (!isTokenExpired) {
      if (cntx.mounted) {
        Navigator.pushReplacementNamed(cntx, "/dashboard");
      }
    }
  } catch (_) {
    return;
  }
  return;
}
