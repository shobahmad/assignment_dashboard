import 'package:assignment_dashboard/bloc/auth/login_bloc.dart';
import 'package:assignment_dashboard/bloc/auth/login_state.dart';
import 'package:assignment_dashboard/ui/auth/splash.dart';
import 'package:assignment_dashboard/ui/common/field_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


LoginBloc bloc;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {

  bool authorized = false;

  @override
  void initState() {
    bloc = LoginBloc();
    super.initState();
  }
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFFFFFFF),
        toolbarHeight: 200,
        centerTitle: true,
        title: Column(children: [
          SizedBox(height: 24),
          Image(
              image: AssetImage('assets/images/logo.png'),
              width: 128),
          SizedBox(height: 12),
        ],),
      ),
      body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0),
                            child: StreamBuilder(
                                stream: bloc.state,
                                builder:
                                    (context, AsyncSnapshot<LoginStream> snapshot) {

                                  if (snapshot.hasData &&
                                      snapshot.data.state == LoginState.loading) {
                                    return LoginForm(true, null);
                                  }

                                  if (snapshot.hasData &&
                                      snapshot.data.state == LoginState.failed) {
                                    return LoginForm(false, snapshot.data.message);
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data.state == LoginState.success) {
                                      Future.delayed(const Duration(seconds: 0), () {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                                      });
                                    return Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: SpinKitThreeBounce(
                                          color: Colors.blueGrey,
                                          size: 50.0,
                                        ),
                                      ),
                                    );
                                  }

                                  return LoginForm(false, null);
                                })))
                  ]))),
    );
  }
}

class LoginForm extends StatefulWidget {
  String errorMessage = "";
  bool loading = false;

  LoginForm(this.loading, this.errorMessage);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textUsernameController;
  TextEditingController textPasswordController;

  @override
  void initState() {
    super.initState();
    textUsernameController = TextEditingController();
    textPasswordController = TextEditingController();
  }
  @override
  void dispose() {
    textUsernameController.dispose();
    textPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);
    const inkWellStyle = TextStyle(color: Color(0xFFFABC37), fontSize: 12);
    const warningStyle = TextStyle(color: Color(0xFFB33A3A), fontSize: 12);

    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: <Widget>[
              sizedBoxSpace,
              TextFormField(
                controller: textUsernameController,
                enabled: !widget.loading,
                cursorColor: cursorColor,
                decoration: InputDecoration(
                    filled: false,
                    icon: const Icon(Icons.person),
                    hintText: 'Username',
                    labelText: 'Username'),
              ),
              sizedBoxSpace,
              PasswordField(
                controller: textPasswordController,
                enabled: !widget.loading,
                helperText:
                'Password no more than 20',
                labelText: 'Password',
              ),
              sizedBoxSpace,
              RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                onPressed: widget.loading
                    ? null : () {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    bloc.postLogin(textUsernameController.text, textPasswordController.text);
                  }
                },
                child: Container(
                  width: 277,
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(vertical: 20),
                    child: Center(
                      child: widget.loading ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18.0,
                      ) : Text('Sign-In'),
                    ),
                  ),
                ),
              ),
              sizedBoxSpace,
              sizedBoxSpace,
              sizedBoxSpace,
              widget.errorMessage == null
                  ? Container()
                  : Center(
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: <Widget>[
                    InkWell(
                        child: Text(
                          widget.errorMessage,
                          textAlign:
                          TextAlign.center,
                          style: warningStyle,
                        )),
                  ],
                ),
              )
            ]));

  }
}


