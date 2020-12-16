import 'package:assignment_dashboard/bloc/auth/login_bloc.dart';
import 'package:assignment_dashboard/bloc/auth/login_state.dart';
import 'package:assignment_dashboard/ui/auth/login.dart';
import 'package:assignment_dashboard/ui/common/field_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordScreentate();
  }
}

class ChangePasswordScreentate extends State<ChangePasswordScreen> {
  LoginBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = LoginBloc();
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
        title: Text("Change Password"),
      ),
      body: StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<LoginStream> snapshot) {
            Widget header = Container();
            submitCallback(String oldPassword, String newPassword) {
                bloc.postChangePassword(oldPassword.trim(), newPassword.trim());
            }
            Widget form = ChangePasswordForm(submitCallback);

            if (snapshot.hasData && snapshot.data.state == LoginState.loading) {
              form = ChangePasswordForm.loading();
            }
            if (snapshot.hasData && snapshot.data.state == LoginState.failed) {
              form = ChangePasswordForm.error(snapshot.data.message, submitCallback);
            }
            if (snapshot.hasData && snapshot.data.state == LoginState.success) {
              form = ChangePasswordForm.success(submitCallback);
            }

            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.down,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 48.0,),
                    header,
                    SizedBox(height: 24.0,),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: form,
                      ),
                    )
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  String errorMessage = null;
  bool loading = false;
  bool success = false;
  void Function(String oldPassword, String newPassword) onSubmitCallback;

  ChangePasswordForm(this.onSubmitCallback);
  ChangePasswordForm.loading() {
    this.loading = true;
  }
  ChangePasswordForm.error(this.errorMessage, this.onSubmitCallback);
  ChangePasswordForm.success(this.onSubmitCallback) {
    this.success = true;
  }

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordFormState();
  }
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textOldPasswordController;
  TextEditingController textNewPasswordController;
  TextEditingController textRetypePasswordController;

  @override
  void initState() {
    super.initState();
    textOldPasswordController = TextEditingController();
    textNewPasswordController = TextEditingController();
    textRetypePasswordController = TextEditingController();
  }
  @override
  void dispose() {
    textOldPasswordController.dispose();
    textNewPasswordController.dispose();
    textRetypePasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    const warningStyle = TextStyle(color: Color(0xFFB33A3A), fontSize: 12);

    if (widget.success) {
      return Column(
        children: [
          Lottie.asset(
            'assets/animation/success-tick.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 24,),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                  'Password successfully updated',
              textAlign: TextAlign.center,),
            ),
          )
        ],
      );
    }

    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: <Widget>[
              sizedBoxSpace,
              PasswordField(
                  controller: textOldPasswordController,
                  enabled: !widget.loading,
                  labelText: 'Old Password',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter old password';
                    }
                    return null;
                  }),
              sizedBoxSpace,
              PasswordField(
                controller: textNewPasswordController,
                enabled: !widget.loading,
                labelText: 'New Password',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Please enter at least 6 characters';
                    }
                    return null;
                  }
              ),
              sizedBoxSpace,
              PasswordField(
                controller: textRetypePasswordController,
                enabled: !widget.loading,
                labelText: 'Retype Password',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please retype new password';
                    }
                    if (value != textNewPasswordController.text) {
                      return 'Invalid new password. Please retype new password correctly';
                    }
                    return null;
                  }
              ),
              sizedBoxSpace,
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: widget.loading
                    ? null : () {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    widget.onSubmitCallback(textOldPasswordController.text, textNewPasswordController.text);
                  }
                },
                child: Container(
                  width: 277,
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(vertical: 16),
                    child: Center(
                      child: widget.loading ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18.0,
                      ) : Text('Change Password'),
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
