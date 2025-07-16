import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/loginpage.dart';
import 'package:freelancing_app/main.dart';
import 'package:freelancing_app/uihelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signUp(String email, String password, String name, String phone, String address) async
  {
    if (email == "" && password == "" && name == "" && phone == "" && address == "")
    {
      UiHelper.CustomAlertBox(context, "Enter Required Fields!");
    }
    else
    {
      UserCredential? userCredential;
      try
      {
        // Firebase Auth - Signup
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // Store additional user details in Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'uid': userCredential.user?.uid,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful!')),
        );

        // Navigate to Home or Login page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

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
        title: Text("Sign Up Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 30),

            Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            UiHelper.CustomTextField(nameController, "Full Name / Company Name", Icons.person, false),

            UiHelper.CustomTextField(emailController, "Email", Icons.email, false),

            UiHelper.CustomTextField(passwordController, "Password", Icons.password, true),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: TextField(
                controller: phoneController,
                obscureText: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Phone Number",
                    suffixIcon: Icon(Icons.phone_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),

            UiHelper.CustomTextField(addressController, "Address", Icons.location_on, false),

            SizedBox(height: 30),

            UiHelper.CustomButton(()
            {
              signUp(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  nameController.text.toString(),
                  phoneController.text.toString(),
                  addressController.text.toString());
            }, "Sign Up"),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Login",
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
