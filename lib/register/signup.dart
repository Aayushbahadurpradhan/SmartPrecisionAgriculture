
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/global_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  var _isVisible = false;
  var _isVisibleConfirm = false;

  late AuthViewModel _authViewModel;
  late GlobalUIViewModel _ui;

  @override
  void initState() {
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    super.initState();
  }
  void register() async {
    if (formkey.currentState == null || !formkey.currentState!.validate()) {
      return;
    }
    _ui.loadState(true);
    try {
      await _authViewModel
          .register(UserModel(
        username: username.text,
        email: email.text,
        phone: phoneNo.text,
        password: password.text,
        id: '',
      ))
          .then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Register success")));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (BuildContext context) => OnboardingScreen(),
        // ));
        Navigator.of(context).pushReplacementNamed("/login");
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
    _ui.loadState(false);
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
        body: SingleChildScrollView(
        child: Container(
        width: double.infinity,
        child: Form(
        key: formkey,
        child: SingleChildScrollView(
        child: Column(
        children: [
        Container(
        height: deviceHeight * 0.20,
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
    const Text(
    'Register Account',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: constraints.maxHeight * 0.04),
    TextFormField(
    decoration: InputDecoration(
    prefixIcon: Icon(Icons.people),
    filled: true,
    fillColor: Colors.grey.shade50,
    hintText: ' Username ',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide:
    BorderSide(color: Colors.black12))),
    controller: username,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please enter username";
    }
    },
    ),
    SizedBox(height: constraints.maxHeight * 0.04),
    TextFormField(
    controller: email,
    decoration: InputDecoration(
    prefixIcon: Icon(Icons.email),
    filled: true,
    fillColor: Colors.grey.shade50,
    hintText: ' Email ',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide:
    BorderSide(color: Colors.black12)),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please enter email address";
    }
    },
    ),
    SizedBox(height: constraints.maxHeight * 0.04),
    TextFormField(
    controller: phoneNo,
    decoration: InputDecoration(
    prefixIcon: Icon(Icons.phone),
    filled: true,
    fillColor: Colors.grey.shade50,
    hintText: ' Phone no ',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide:
    BorderSide(color: Colors.black12))),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter mobile number';
    } else if (value.length < 10 ||
    value.length > 10) {
    return 'Please enter valid mobile number';
    }
    return null;
    },
    ),
    SizedBox(height: constraints.maxHeight * 0.04),
    TextFormField(
    controller: password,
    obscureText: _isVisible ? false : true,
    validator: (value){
    if(value==null || value.isEmpty){
    return "Please enter password";
    }
    },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.grey.shade50,
          hintText: ' Password ',
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide:
              BorderSide(color: Colors.black12))),
    ),
      SizedBox(height: constraints.maxHeight * 0.04),
      TextFormField(
        controller: confirmPassword,
        obscureText: _isVisibleConfirm ? false : true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter confirm password";
          } else if (password.text !=
              confirmPassword.text) {
            return "Password and confirm password must be same";
          }
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            filled: true,
            fillColor: Colors.grey.shade50,
            hintText: ' Confirm password ',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isVisibleConfirm = !_isVisibleConfirm;
                });
              },
              icon: Icon(
                _isVisibleConfirm
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide:
                BorderSide(color: Colors.black12))),
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
            register();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Register Now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      RichText(
        text: TextSpan(
          text: "Already have an account?   ",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          children: [
            TextSpan(
              text: "Login",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigator.of(context)
                  //     .pushReplacement(MaterialPageRoute(
                  //   builder: (BuildContext context) =>
                  //       LoginScreens(),
                  // ));
                },
            )
          ],
        ),
      ),
    ],
    );
    }),
    ),
        ],
        ),
        ),
        ),
        ),
        ),
        ),
    );

  }
}
