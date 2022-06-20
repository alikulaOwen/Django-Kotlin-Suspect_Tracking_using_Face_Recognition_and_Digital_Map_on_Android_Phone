import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:njia/ProgressHUD.dart';
import 'package:njia/models/register_officer_model.dart';
import 'package:njia/screens/home.dart';
import 'package:njia/services/register_officer_service.dart';
import 'package:path/path.dart' as path;
import 'package:validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late RegisterOfficerRequestModel requestModel;
  bool isAPICallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = RegisterOfficerRequestModel();
    createOpenBox();
  }

  void createOpenBox() async {
    var box1 = await Hive.openBox('logindata');
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
                          'Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (input) => requestModel.email = input!,
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
                        // National Id/Passport Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'National Id / Passport No',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (input) =>
                                    requestModel.national_id = input!,
                                validator: (input) => input == ''
                                    ? "Employee Id can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(),
                                    prefix: Icon(
                                      Icons.perm_identity,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Natonal Id / Passport No',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Employee Id
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Employee Id',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (input) =>
                                    requestModel.employee_id = input!,
                                validator: (input) => input == ''
                                    ? "Employee Id can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(),
                                    prefix: Icon(
                                      Icons.factory,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Employee Id',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // UserName
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Username',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                onSaved: (input) =>
                                    requestModel.username = input!,
                                validator: (input) => input == ''
                                    ? "Username can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(),
                                    prefix: Icon(
                                      Icons.person,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Username',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Password
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
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
                        // Confirm Password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Confirm Password',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                obscureText: true,
                                onSaved: (input) =>
                                    requestModel.password2 = input!,
                                validator: (input) => input == ''
                                    ? "Confirm Password can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefix: Icon(
                                      Icons.lock,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'Repeat Password',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Phone Number
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Phone Number',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                onSaved: (input) =>
                                    requestModel.phone_number = input!,
                                validator: (input) => input == ''
                                    ? "Phone Number can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefix: Icon(
                                      Icons.phone_android,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: '+254...',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Department
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Department',
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
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ]),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (input) =>
                                    requestModel.department = input!,
                                validator: (input) => input == ''
                                    ? "Department can't be empty"
                                    : null,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefix: Icon(
                                      Icons.house,
                                      color: Color(0xff5ac18e),
                                    ),
                                    hintText: 'DCI, Kenya Police, ATP',
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (validateAndSave()) {
                                setState(() {
                                  isAPICallProcess = true;
                                });
                                RegisterOfficerService loginService =
                                    RegisterOfficerService();
                                loginService
                                    .register(requestModel)
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      isAPICallProcess = false;
                                    });
                                  }
                                });

                                print(requestModel.password);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(15)),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Color(0xff5ac18e),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: 'Login',
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
}
