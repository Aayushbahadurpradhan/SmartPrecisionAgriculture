import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dashboard.dart';
import '../register/signup.dart';
import '../viewmodel/auth_view_model.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({Key? key}) : super(key: key);

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final form = GlobalKey<FormState>();
  var _isVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthViewModel auth;
  @override
  void initState() {
    auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> login() async {
    try {
      await auth.login(emailController.text, passwordController.text);
      if (auth.user != null) {
        print("Login Sucessful");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("Login Sucessful")));
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 40),
                  height: deviceHeight * 0.30,
                  child: Image.asset('images/logo.png'),
                ),
                Container(
                  height: deviceHeight * 0.75,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(builder: (ctx, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.04),
                        Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                              color: const Color(0xffB4B4B4).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Center(
                              child: TextFormField(
                                controller: emailController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.04),
                        Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                              color: const Color(0xffB4B4B4).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Center(
                              child: TextFormField(
                                controller: passwordController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  return null;
                                },
                                obscureText: _isVisible ? false : true,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isVisible = !_isVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _isVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Enter your password"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.12,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.01,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/forgotpassword");
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.08,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Dont have account?    ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
