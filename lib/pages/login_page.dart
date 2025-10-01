import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/customButtonauth.dart';
import 'package:chatify/widgets/customTextFormField.dart';
import 'package:chatify/widgets/customtextauth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceheight;
  late double _deviceWith;
  late AuthenticationProvider _auth;
  late NavigationService _navigationService;
  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _deviceWith = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildUi();
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceheight * 0.1,
      child: Text(
        "Chatify",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _pagelogo() {
    return SizedBox(
        height: _deviceheight * 0.2,
        child: Image.asset("assets/images/chat.png"));
  }

  Widget _loginForm() {
    return SizedBox(
      height: _deviceheight * 0.25,
      child: Form(
          child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Customtextformauth(
                    hinText: "Enter your email",
                    regEx:
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    labelText: "Email",
                    iconData: Icons.person,
                    myController: emailController,
                    isNumber: false,
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  Customtextformauth(
                    hinText: "Enter your password",
                    regEx: r".{8,}",
                    labelText: "Password",
                    iconData: Icons.lock,
                    myController: passwordController,
                    isNumber: false,
                    obscureText: false,
                  ),
                ],
              ))),
    );
  }

  Widget _loginButton() {
    return CustomButtonAuth(
      text: "Login",
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          print("Email: ${emailController.text}");
          print("Password: ${passwordController.text}");
          _auth.loginWithEmail(emailController.text, passwordController.text);
        }
      },
      height: _deviceheight * 0.055,
      width: _deviceWith,
    );
  }

  Widget _registerAccountLink() {
    return CustomTextSignupOrSignIn(
      textone: "Don't Have An Acount?",
      texttwo: "Sign Up",
      onTap: () {
        _navigationService.navigateToRoute('/signup');
      },
    );
  }

  Widget _buildUi() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWith * 0.03,
          vertical: _deviceheight * 0.02,
        ),
        height: _deviceheight * 0.98,
        width: _deviceWith * 0.97,
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            _pagelogo(),
            const SizedBox(height: 20),
            _pageTitle(),
            const SizedBox(height: 20),
            _loginForm(),
            _loginButton(),
            const SizedBox(height: 30),
            _registerAccountLink()
          ],
        ),
      ),
    );
  }
}
