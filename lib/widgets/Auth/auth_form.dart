import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {super.key});

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPass = '';
  var _userName = '';
  File? _userImageFile;

  late SnackBar snackBar;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile?.path.isEmpty != false && !_isLogin) {
      snackBar = SnackBar(
        content: const Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPass.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Enter a valid Meail Address';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _userEmail = newValue!,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Passsword must be atleast 4 characters long.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _userName = newValue!,
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Passsword must be atleast 6 characters long.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _userPass = newValue!,
                    ),
                    const SizedBox(height: 12),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: () {
                          _trySubmit();
                        },
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new Account'
                            : 'I already have an account'),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
