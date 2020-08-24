import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this._submitAuthForm, this._isLoading);

  final bool _isLoading;
  final void Function(String email, String username, String password,
      bool isLogged, bool isForgot, BuildContext context) _submitAuthForm;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogged = false;
  bool _isForgot = false;
  String _email = '';
  String _username = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget._submitAuthForm(
          _email, _username, _password, _isLogged, _isForgot, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return "Please enter a valid email!";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _email = newValue;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      style: Theme.of(context).textTheme.bodyText2),
                  SizedBox(
                    height: 5,
                  ),
                  if (!_isLogged && !_isForgot)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Please enter atleast 5 chars !';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _username = newValue;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Username',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  if (!_isForgot)
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Please enter atleast 7 chars !';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _password = newValue;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      style: Theme.of(context).textTheme.bodyText2,
                      obscureText: true,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget._isLoading)
                    CircularProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  if (!widget._isLoading)
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      onPressed: _trySubmit,
                      child: _isForgot
                          ? Text('Send Recovery Email ',
                              style: TextStyle(color: Colors.white))
                          : _isLogged
                              ? Text('Log In ',
                                  style: TextStyle(color: Colors.white))
                              : Text('Sign up ',
                                  style: TextStyle(color: Colors.white)),
                    ),
                  SizedBox(height: 5),
                  if (!widget._isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!_isForgot)
                          RaisedButton(
                              color: Theme.of(context).primaryColor,
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              onPressed: () => setState(() {
                                    _isLogged = !_isLogged;
                                  }),
                              child: _isLogged
                                  ? Text('Create new user',
                                      style: TextStyle(color: Colors.white))
                                  : Text('Already a user?',
                                      style: TextStyle(color: Colors.white))),
                        RaisedButton(
                            color: Theme.of(context).primaryColor,
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            onPressed: () => setState(() {
                                  _isForgot = !_isForgot;
                                }),
                            child: !_isForgot
                                ? Text('Forgot Password',
                                    style: TextStyle(color: Colors.white))
                                : Text('Already a user?',
                                    style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  SizedBox(height: 5),
                ],
              ),
            )),
      ),
    );
  }
}
