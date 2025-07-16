import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/forgotpassword.dart';
import 'package:freelancing_app/job_screen.dart';
import 'package:freelancing_app/signuppage.dart';
import 'package:freelancing_app/uihelper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  login(String email, String password) async
  {
    if (email == "" && password == "")
    {
      UiHelper.CustomAlertBox(context, "Enter Required Fields!");
    }
    else
    {
      UserCredential userCredential;
      try
      {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')),
        );

        // Navigate to home page after successful login
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => JobScreen()),
              (Route<dynamic> route) => false,  // Clears all previous routes
        );
      }
      on FirebaseAuthException catch (ex)
      {
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
      ),
      ),

      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 100,),

              Text(
                "Login",
                style: TextStyle(
                    color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),
              UiHelper.CustomTextField(emailController, "Email", Icons.email, false),
              UiHelper.CustomTextField(passwordController, "Password", Icons.password, true),
              SizedBox(height: 5),

              SizedBox(
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                        onPressed: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                        },
                        child: Text(
                          "Forgot password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              UiHelper.CustomButton(()
              {
                login(emailController.text.toString(), passwordController.text.toString());
                }, "Login"),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),

                  TextButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
