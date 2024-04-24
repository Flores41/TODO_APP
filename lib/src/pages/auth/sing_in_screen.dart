import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/authentication_provider.dart';
import '../../utils/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticacionProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(CupertinoIcons.mail_solid),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                    .hasMatch(val)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                    .hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = CupertinoIcons.eye_fill;
                    } else {
                      iconPassword = CupertinoIcons.eye_slash_fill;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
          ),
          const SizedBox(height: 20),
        
        authProvider.getisLoading? const CircularProgressIndicator():  SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await authProvider
                        .signInWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        )
                        .then((value) =>
                            Navigator.pushReplacementNamed(context, '/home'));
                  } catch (e) {
                    _errorMsg = 'Email o  Contraseña incorrecta';
                  }
                }
              },
              style: TextButton.styleFrom(
                  elevation: 7.0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60))),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
