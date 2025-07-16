import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/uihelper.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  fogotpassword(String email) async {
    if (email == "")
    {
      return UiHelper.CustomAlertBox(context, "Enter an email to reset password!");
    }
    else
    {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      UiHelper.CustomAlertBox(context, "We have e-mailed your password reset link!");
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Forgot Password",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),
          UiHelper.CustomTextField(emailController, "Email", Icons.email, false),

          SizedBox(height: 20),
          UiHelper.CustomButton(()
          {
            fogotpassword(emailController.text.toString());
          }, "Reset Password")
        ],
      ),
    );
  }
}
