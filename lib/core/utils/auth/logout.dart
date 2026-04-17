import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

void logout(BuildContext cntx) async {
  await FlutterSessionJwt.deleteToken();

  if (cntx.mounted) {
    Navigator.pushReplacementNamed(cntx, "/");
  }
}
