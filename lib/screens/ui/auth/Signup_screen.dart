// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../utils/utils.dart';
// import '../../widgets/round_button.dart';
// import 'login_screen.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void login() {
//     setState(() {
//       loading = true;
//     });
//     _auth.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     ).then((value) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(),
//         ),
//       );
//       setState(() {
//         loading = false;
//       });
//     }).onError((error, stackTrace) {
//       Utils().toastMessage(error.toString());
//       setState(() {
//         loading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.1),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 200),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.alternate_email_outlined),
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.lock_open),
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   RoundButton(
//                     title: "Sign Up",
//                     loading: loading,
//                     ontap: () {
//                       if (_formKey.currentState!.validate()) {
//                         login();
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text("Login"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
