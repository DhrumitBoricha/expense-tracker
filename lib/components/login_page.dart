import 'package:construction_app/components/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Screens/Home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController login_email;
  late TextEditingController login_pass;
  bool isLoading = false; // Add loading state

  final _fauth13 = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    login_email = TextEditingController();
    login_pass = TextEditingController();

    // Check if user is already logged in after the build process
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkCurrentUser();
    });
  }

  checkCurrentUser() async {
    User? user = _fauth13.currentUser;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>MoneyHome()));
    }
  }

  login() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      await _fauth13.signInWithEmailAndPassword(email:login_email.text , password: login_pass.text).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>MoneyHome()));
      }).onError(( FirebaseAuthException error, stackTrace) {
        Fluttertoast.showToast(msg: error.message.toString());
      });
    } on FirebaseAuthException catch(error) {
      Fluttertoast.showToast(msg: error.message.toString());
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void dispose() {
    login_email.dispose();
    login_pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: login_email,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: login_pass,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            login();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color(0xFF0C0C3D),
          ),
          child: isLoading ? CircularProgressIndicator() : const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot password?",
        style: TextStyle(color: Color(0xFF0C0C3D)),
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));

            },
            child: const Text("Sign Up", style: TextStyle(color: Color(0xFF0C0C3D)),)
        )
      ],
    );
  }
}
