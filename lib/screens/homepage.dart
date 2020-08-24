import 'package:GDrive_connect/services/google_drive.dart';
import 'package:GDrive_connect/widgets/appbar.dart';
import 'package:GDrive_connect/widgets/speed_dail.dart';
import 'package:flutter/material.dart';
import 'package:GDrive_connect/services/drive_path.dart';
import 'package:googleapis/servicenetworking/v1.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _drivePath = DrivePath();
  final _drive = GoogleDrive();

  Future callback() async {
    setState(() {});
  }

  Future getListItems() async {
    if (!await _drive.checkConnectionStatus()) {
      return null;
    } else if (await _drive.getRootId() == null) {
      return null;
    } else {
      return await _drive.getFolderItemsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'page',
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBarWidget(_drive, callback, _drivePath)),
        body: Container(
          padding: EdgeInsets.all(15),
          child: FutureBuilder(
              future: getListItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var fileList = snapshot.data;
                  if (fileList == null) {
                    return Center(
                        child: Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text(
                            'Disconnected',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Text(
                            'Connect through top toggle',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ));
                  } else if (fileList.files.length == 0) {
                    return Center(
                        child: Text(
                      'Folder Empty',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ));
                  }
                  print(fileList.toString());
                  return ListView.builder(
                    itemCount: fileList.files.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 5,
                        child: ListTile(
                          leading: (fileList.files[index].mimeType ==
                                  'application/vnd.google-apps.folder')
                              ? Icon(
                                  Icons.folder,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.insert_drive_file,
                                  color: Theme.of(context).primaryColor,
                                ),
                          title: Text(fileList.files[index].name),
                          trailing: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).errorColor),
                              onPressed: () async {
                                await _drive.delete(fileList.files[index].id);
                                callback();
                              }),
                          onTap: () async {
                            if (fileList.files[index].mimeType ==
                                'application/vnd.google-apps.folder') {
                              await _drive.setRootId(fileList.files[index].id);
                              _drivePath.pushPath(fileList.files[index].name);
                              callback();
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              }),
        ),
        floatingActionButton: SpeedDialWidget(_drive, callback),
      ),
    );
  }
}
