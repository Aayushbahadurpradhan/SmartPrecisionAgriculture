
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

