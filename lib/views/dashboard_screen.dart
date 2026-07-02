import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/user_provider.dart';
import 'package:pharmaciano/core/utils/auth/logout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void confirmLogout(BuildContext ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Confirm:"),
        content: Text("Are you sure want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              logout(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Center(
      child: ClipRect(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 440),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
              centerTitle: true,
              backgroundColor:
                  Colors.blue, //Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15) ,bottomRight: Radius.circular(15))),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pos');
                  },
                  icon: Icon(Icons.barcode_reader),
                  tooltip: "POS",
                ),
              ],
            ),
            body: Center(
              child: Consumer(
                builder: (context, ref, child) {
                  final profilePrvdr = ref.watch(profileProvider);
                  return profilePrvdr.when(
                    data: (data) {
                      return (data != null)
                          ? Text(
                              "Welcome, ${data.data!.profile!.name!.toUpperCase()}",
                            )
                          : const CircularProgressIndicator();
                    },
                    error: (error, stack) {
                      if (kDebugMode) {
                        print(error);
                        print(stack);
                      }
                      return Text("Something went wrong!");
                    },
                    loading: () => const CircularProgressIndicator(),
                  );
                },
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(child: Center(child: Text("Pharmaciano"))),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () => confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
