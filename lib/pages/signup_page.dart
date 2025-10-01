import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloudstorage_servce.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/customButtonauth.dart';
import 'package:chatify/widgets/customTextFormField.dart';
import 'package:chatify/widgets/customprofileimage.dart';
import 'package:chatify/widgets/customtextauth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late double _deviceHeight;
  late double _deviceWdidth;

  final _registerFromkey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  late NavigationService _navigationService;
  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudstorageService _cloudstorageService;

  PlatformFile? _profilePicture;
  @override
  void initState() {
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWdidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudstorageService = GetIt.instance.get<CloudstorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();

    return _builui();
  }

  Widget _profileImage() {
    return InkWell(
      onTap: () {
        GetIt.instance.get<MediaService>().pickeImageFromLibrary().then((
          file,
        ) {
          setState(() {
            _profilePicture = file;
          });
        });
      },
      child: () {
        if (_profilePicture != null) {
          return RoundedImageFile(
            image: _profilePicture!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            imagePath: "https://i.pravatar.cc/150?img=65",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFromkey,
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
            Customtextformauth(
              hinText: "Enter your username",
              regEx: r".{8,}",
              labelText: "Username",
              iconData: Icons.person_4,
              myController: usernameController,
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
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return CustomButtonAuth(
      text: "Sign Up",
      onPressed: () async {
        if (_registerFromkey.currentState!.validate() &&
            _profilePicture != null) {
          String? uid = await _auth.registerUserWithEmail(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
          String? imageUrl = await _cloudstorageService.saveuserImageToStorage(
            uid!,
            _profilePicture!,
          );
          await _db.createUser(
            uid,
            emailController.text.trim(),
            passwordController.text.trim(),
            imageUrl!,
          );
          // 4) Déconnecter le nouvel utilisateur (logout) pour repartir sur /login
          await _auth.logout();

          // 5) Rediriger vers la page de login
          _navigationService.removeAndNavigatteToRoute("/login");

          // OPTIONNEL : afficher un message de confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Compte créé, merci de vous connecter."),
            ),
          );
        }
      },
      height: _deviceHeight * 0.055,
      width: _deviceWdidth,
    );
  }

  Widget _registerAccountLink() {
    return CustomTextSignupOrSignIn(
      textone: "Have An Acount?",
      texttwo: "Sign In",
      onTap: () {
        _navigationService.removeAndNavigatteToRoute("/login");
      },
    );
  }

  Widget _builui() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWdidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWdidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            _profileImage(),
            _registerForm(),
            _signUpButton(),
            const SizedBox(height: 30),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }
}
