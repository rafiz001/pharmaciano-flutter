import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/login_providers.dart';
import 'package:pharmaciano/core/utils/auth/check_already_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  void autoFillDialog(BuildContext ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Auto Fill"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Super Admin"),
                IconButton(
                  onPressed: () {
                    _emailController.text = "superadmin@pharmaciano.com";
                    _passwordController.text = "superadmin123";
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_return),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Sales Man"),
                IconButton(
                  onPressed: () {
                    _emailController.text = "rafiz001@gmail.com";
                    _passwordController.text = "rafiz123";
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_return),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    checkIsAlreadyLoggedIn(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // For light icons
        // Or use Brightness.dark for dark icons
      ),
    );
    // double screenWidth = MediaQuery.of(context).size.width;
    // print("from build");
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 440),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ClipPath(
                          clipper: MyClipper(),
                          child: Image.asset(
                            "assets/tech_wall.jpg",
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pharmaciano",
                              style: TextStyle(color: Colors.black),
                            ),
                            Padding(padding: EdgeInsetsGeometry.only(top: 80)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    // fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -70,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            // padding: screenWidth > 440
                            //     ? EdgeInsetsGeometry.only(left: 100, right: 100)
                            //     : EdgeInsetsGeometry.all(10),
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sign In", textAlign: TextAlign.left),
                                Container(
                                  height: 2,
                                  width: 50,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: "Email",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email should not null';
                                    } else if (!value.contains("@")) {
                                      return 'Enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                                Consumer(
                                  builder: (context, refr, child) {
                                    final passVisible = refr.watch(
                                      passVisibleProvider,
                                    );
                                    return TextFormField(
                                      controller: _passwordController,
                                      obscureText: passVisible,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            refr
                                                .read(
                                                  passVisibleProvider.notifier,
                                                )
                                                .toggle();
                                          },
                                          icon: Icon(
                                            passVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 10),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    Checkbox(
                                      value: true,
                                      onChanged: (value) => {},
                                      splashRadius: 0,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                      ),
                                    ),
                                    Text("Remember Me"),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final loginProviderI = ref.watch(
                                      loginProvider,
                                    );
                                    ref.listen<AsyncValue>(loginProvider, (
                                      previous,
                                      state,
                                    ) {
                                      // Show only when transitioning TO an error state
                                      if (previous?.hasError == false &&
                                          state.hasError) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error on logging in.',
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                    return SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          side: BorderSide(color: Colors.blue),
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                        ),
                                        onPressed: () {
                                          bool isFormOk = _formKey.currentState!
                                              .validate();
                                          if (isFormOk) {
                                            ref
                                                .read(loginProvider.notifier)
                                                .login(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  context,
                                                );
                                          }
                                        },
                                        child: loginProviderI.when(
                                          data: (data) {
                                            return const Text("Login");
                                          },
                                          loading: () =>
                                              CircularProgressIndicator(),
                                          error: (error, stackTrace) {
                                            if (kDebugMode) {
                                              print(error);
                                              print(stackTrace);
                                            }
                                            return const Text("Login");
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            autoFillDialog(context);
          },
          child: Icon(Icons.dynamic_feed_rounded),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height,
      size.width * 0.5,
      size.height - 60 - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 60 - 100,
      0,
      size.height - 60 - 60,
    );

    // path.lineTo(0,size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
