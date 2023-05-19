import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../pages/Login.dart';

class Navbar extends StatefulWidget {
  Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        Color(0xffffd04f), Color(0xFFFFF9C5), // Very Light Yellow
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_rounded),
                  title: Text(
                    "${loggedInUser.firstName} ${loggedInUser.secondName}"
                        .toUpperCase(),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(
                    "${loggedInUser.email} ",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                InkWell(
                  onTap: () {
                    // Use PushNamed Function of Navigator class to push the named route
                    Navigator.pushNamed(context, 'login');
                  },
                  child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () {
                        logout(context);
                      }),
                ),
                const SizedBox(
                  height: 475,
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
}
