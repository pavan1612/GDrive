import 'package:GDrive_connect/screens/authpage.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AppBarWidget extends StatefulWidget {
  final _drive;
  var _drivePath;
  Function callback;
  AppBarWidget(this._drive, this.callback, this._drivePath);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 15,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      centerTitle: false,
      actions: <Widget>[
        DropdownButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          items: [
            DropdownMenuItem(
                child: Container(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                value: 'logout'),
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'logout') {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => AuthPage()));
            }
          },
        )
      ],
      title: Text(
        "Google Drive",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
                future: widget._drive.checkConnectionStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    return ToggleSwitch(
                      minWidth: 115.0,
                      cornerRadius: 20.0,
                      activeBgColor: snapshot.data ? Colors.green : Colors.red,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      labels: ['Connect', 'Disconnect'],
                      icons: [Icons.cloud_done, Icons.cloud_off],
                      initialLabelIndex: snapshot.data ? 0 : 1,
                      onToggle: (index) async {
                        if (index == 1) {
                          await widget._drive.disconnect();
                          widget._drivePath.resetPath();
                        }
                        if (index == 0) {
                          await widget._drive.connect();
                        }
                        widget.callback();
                      },
                    );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (await widget._drive.goBack()) {
                      widget._drivePath.popPath();
                      widget.callback();
                    } else
                      return;
                  },
                ),
                Flexible(
                  child: Text(
                    widget._drivePath.getCuurentPath(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
