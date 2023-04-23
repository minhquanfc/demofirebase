import 'package:demofirebase/screens/ListItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demofirebase/screens/SignIn.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListTodo(),
            ));
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Text(
    //       "Login",
    //       style: TextStyle(color: Colors.black, fontSize: 35),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    //       child: TextField(
    //         controller: emailController,
    //         decoration: InputDecoration(
    //             labelText: "Email",
    //             border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10))),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    //       child: TextField(
    //         controller: passController,
    //         decoration: InputDecoration(
    //             labelText: "Password",
    //             border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10))),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
    //       child: ElevatedButton(
    //         onPressed: () {
    //           if(emailController.text.isEmpty || passController.text.isEmpty){
    //             return print("Vui long khong de trong");
    //           }
    //           FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
    //         },
    //         style: ButtonStyle(
    //           backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    //           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
    //             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //           ),
    //           minimumSize:
    //               MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
    //         ),
    //         child: const Text("Login"),
    //       ),
    //     )
    //   ],
    // );
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Hello Again!",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Email"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: passController,
                  obscureText: true,

                  /// an pass
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () {
                  signIn(emailController.text, passController.text);
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?,"),
                  TextButton(
                    child: Text("Sign in"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      return showToast("Vui lòng nhập thông tin");
    } else if (!EmailValidator.validate(email)) {
      showToast('Email sai định dạng.');
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListTodo(),
          ));
      showToast("Đăng nhập thành công");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("Không tìm thấy người dùng nào cho email đó.");
      } else if (e.code == 'wrong-password') {
        showToast("Mật khẩu sai.");
      }
    }
  }

  void showToast(String text) {
    try {
      Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on MissingPluginException catch (e) {
      print(e);
    }
  }
}
