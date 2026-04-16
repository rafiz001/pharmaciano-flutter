import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/login_providers.dart';

class LoginScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // print("from build");
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email should not null';
                    } else if (!value.contains("@")) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.visibility),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsetsGeometry.only(top: 5, bottom: 5)),
                Consumer(
                  builder: (context, ref, child) {
                    final loginProviderI = ref.watch(loginProvider);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        bool isFormOk = _formKey.currentState!.validate();
                        if (isFormOk) {
                          ref.read(loginCredentialProvider.notifier).state = [
                            _emailController.text,
                            _passwordController.text,
                          ];
                          ref.invalidate(loginProvider);
                          
                        }
                      },
                      child: loginProviderI.when(
                        data: (data) => Text("got data"),
                        loading: () => CircularProgressIndicator(),
                        error: (error, stackTrace) => Text(error.toString()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          autoFillDialog(context);
        },
        child: Icon(Icons.dynamic_feed_rounded),
      ),
    );
  }
}
