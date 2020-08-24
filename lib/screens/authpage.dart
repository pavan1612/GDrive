import 'package:GDrive_connect/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:GDrive_connect/widgets/auth_form.dart';
import 'package:googleapis/drive/v2.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isloading = false;
  void _submitAuthForm(String email, String username, String password,
      bool isLogged, bool isForgot, BuildContext context) async {
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogged) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => HomePage()));
      } else if (isForgot) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => HomePage()));
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => HomePage()));
      }
    } on Exception catch (err) {
      var message = 'An error occured , check credentials';
      if (err != null) {
        message = err.toString();
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'page',
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
            child: AppBar(
              elevation: 15,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              centerTitle: true,
              title: Text(
                'GDrive',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              bottom: PreferredSize(
                  preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                  child: Expanded(
                      child: Image(image: AssetImage('assets/GDrive.png')))),
            ),
          ),
          body: AuthForm(_submitAuthForm, _isloading)),
    );
  }
}
