import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:njia/ProgressHUD.dart';
import 'package:njia/models/login_model.dart';
import 'package:njia/screens/home.dart';
import 'package:njia/services/login_service.dart';
import 'package:path/path.dart' as path;
import 'package:validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late LoginRequestModel requestModel;
  bool isAPICallProcess = false;
  bool isChecked = true;
  Box? loginCredentials;
  Box? suspectLocations;

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel();
    createOpenBox();
  }

  void createOpenBox() async {
    loginCredentials = await Hive.openBox('logindata');
    //getdata();  // when user re-visit app, we will get data saved in local database
    //how to get data from hive db check it in below steps
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: _uiSetup(context), inAsyncCall: isAPICallProcess, opacity: 0.3);
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0x665ac18e),
                      Color(0x995ac18e),
                      Color(0xcc5ac18e),
                      Color(0xff5ac18e),
                    ])),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // Email Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 60,
                              child: TextFormField(
                                initialValue:
                                    loginCredentials?.get('email') ?? '',
                                onSaved: (input) =>
                                    requestModel.username = input!,
                                validator: (input) =>
                                    !isEmail(input!) ? 'Invalid Email' : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefix: Icon(
                                      Icons.email,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Email',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 60,
                              child: TextFormField(
                                initialValue: loginCredentials?.get('password'),
                                obscureText: true,
                                onSaved: (input) =>
                                    requestModel.password = input!,
                                validator: (input) => input == ''
                                    ? "Password can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefix: Icon(
                                      Icons.lock,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Password',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            )
                          ],
                        ),
                        // Remember me
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (validateAndSave()) {
                                setState(() {
                                  isAPICallProcess = true;
                                });
                                LoginService loginService = LoginService();
                                loginService
                                    .login(requestModel)
                                    .then((value) async {
                                  if (value != null) {
                                    setState(() {
                                      isAPICallProcess = false;
                                    });
                                  }
                                  if (value.token.isNotEmpty) {
                                    loginCredentials!.put('token', value.token);
                                    Fluttertoast.showToast(
                                        msg: "Login Successfull",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Color.fromARGB(255, 94, 87, 87),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pushReplacementNamed(
                                        context, '/map');
                                    if (isChecked) {
                                      loginCredentials!
                                          .put('email', requestModel.username);
                                      loginCredentials!.put(
                                          'password', requestModel.password);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Unseccessfull, check login details",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: const Color.fromARGB(
                                            255, 143, 72, 72),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(15)),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Color(0xff5ac18e),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/register');
                            },
                            child: RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // void login() {
  //   if (isChecked) {
  //     loginCredentials!.put('email', requestModel.username);
  //     loginCredentials!.put('password', requestModel.password);
  //   }
  // }
}
