import 'dart:io';

import 'package:chat_app/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    SnackBar snackBar;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user!.uid}.jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, Please check your credentials!';

      message = err.message!;

      snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      );
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
      // snackBar = SnackBar(
      //   content: Text(err.toString()),
      //   backgroundColor: Theme.of(ctx).errorColor,
      // );
      // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
