import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_fyp/homeScreen.dart';
import 'package:my_fyp/signUpScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var emailText = TextEditingController();
  var pswdText = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool isLoading = false; // New loading state
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _tapRecognizer.dispose(); // Dispose to avoid memory leaks
    emailText.dispose();
    pswdText.dispose();
    super.dispose();
  }

  // Function to show a toast message
  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent.shade200,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Function to handle login
  void login() async {
    if (emailText.text.isEmpty || pswdText.text.isEmpty) {
      showToastMessage("Please fill all fields.");
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Sign in the user
      await _auth.signInWithEmailAndPassword(
          email: emailText.text, password: pswdText.text.toString());

      setState(() {
        isLoading = false; // Hide loading indicator after login
      });

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Hide loading indicator if login fails
      });
      showToastMessage(e.toString()); // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 95, 106, 162), // Custom background color
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailText,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true, // Enable background fill
                    fillColor: Colors.white, // White background color
                    prefixIcon: const Icon(Icons.email),

                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.deepPurple.shade900),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.deepPurple.shade900),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: _obscureText,
                  controller: pswdText,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true, // Enable background fill
                    fillColor: Colors.white, // White background color
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.deepPurple.shade900),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.deepPurple.shade900),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 11),
              isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while signing in
                  : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: login, // Call login function
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.deepPurple.shade900, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15), // Padding
                            elevation: 5, // Shadow depth
                            shape: RoundedRectangleBorder(
                              // Shape of the button
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 11),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
                  children: <TextSpan>[
                    const TextSpan(text: "Don't have an account?"),
                    TextSpan(
                      text: " Sign Up",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.deepPurple.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: _tapRecognizer
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
