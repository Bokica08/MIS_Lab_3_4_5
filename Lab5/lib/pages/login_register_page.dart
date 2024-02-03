import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage ='';
  bool isLogin=true;
  bool _obscureText = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassowrd = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try{
      await Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassowrd.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassowrd.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Widget _title(){
    return const Text("Exam App");
  }

  Widget _entryField(String title, TextEditingController controller) {
    bool isPasswordField = title.toLowerCase() == 'password';
    return TextField(
      controller: controller,
      obscureText: isPasswordField,
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      keyboardType: isPasswordField ? TextInputType.visiblePassword : TextInputType.text,
      autocorrect: false,
      enableSuggestions: false,
    );
  }
  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Hmm ? $errorMessage');
  }
  Widget _submitButton(){
    return ElevatedButton(onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword, child:
    Text(isLogin ? 'Login' : "Register"));
  }

  Widget _loginOrRegisterButton(){
    return TextButton(onPressed: (){
      setState(() {
        isLogin= !isLogin;
      });
    }, child: Text(isLogin ? 'Register here' : "Login here"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password',_controllerPassowrd),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton()
          ],
        ),
      ),
    );;
  }
}
